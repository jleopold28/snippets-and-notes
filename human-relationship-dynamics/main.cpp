//////////////////////////////////////////////////////////////////////////////
//
//Includes and Main
//
//////////////////////////////////////////////////////////////////////////////

#include <iostream>
#include <cmath>
#include <cstdlib>
#include <iomanip>
#include <cstring>
#include <fstream>
#include <vector>
#include <ctime>
#include <sstream>
using namespace std;
#include "main.h"

int main()
{
    function.menu();
    return 0;
}

//////////////////////////////////////////////////////////////////////////////
//
//Utility Functions
//
//////////////////////////////////////////////////////////////////////////////

int functions::rdmgen(int maxnum, long tempstate) //RNG; input "time(NULL)" into "tempstate"
{
    //modified from discrete event simulation p.54
    state += time(NULL); //this line and the next one ensure non-sequential seeding; state must be globally declared
    tempstate += state;
    long t = 48271 * (tempstate % (2147483647 / 48271)) - (2147483647 % 48271) * (tempstate * 48271 / 2147483647);
    if (t > 0)
        tempstate = t;
    else
        tempstate = t + 2147483647;
    return (tempstate % (maxnum + 1));
}
//note from later: time NULL is being passed into tempstate and then state is += time NULL and then tempstate is += state; there is no way this makes sense
//try this -
//int rdmgen(int maxnum)
//{
//    //modified from discrete event simulation p.54
//    state += time(NULL);
//    long t = 48271 * (state % (2147483647 / 48271)) - (2147483647 % 48271) * (state * 48271 / 2147483647);
//    if (t > 0)
//        state = t;
//    else
//        state = t + 2147483647;
//    return (state % (maxnum + 1));
//}

void functions::listpeople() //lists all loaded people
{
    vector<person>::iterator currentperson = vectorofpeople.begin();
    cout << endl << "People:" << endl;
    for (int i = 0; i < vectorofpeople.size(); i++)
    {
        cout << (i + 1) << ". " << currentperson->name << endl; //must have pointer here because of how iterator works
        currentperson++;
    }
}

void functions::listcustompeople() //lists all custom people from text files
{
    cout << "Custom People Slots:" << endl;
    for (int i = 1; ; i++)
    {
        string name;
        ifstream customlist(function.customslot(i).c_str());
        if (!customlist.is_open()) //checks if file exists and exits loop if does not
            break;
        getline(customlist, name, '\n'); //blank line at beginning of text files for some reason when using getline for ofstream
        getline(customlist, name, '\n'); //grabs name from text file for display
        cout << i << ". " << name << endl;
        customlist.close();
    }
}

void functions::preloader() //loads all custom people when program begins
{
    for (int i = 1; ; i++)
    {
        ifstream customlist(function.customslot(i).c_str());
        if (!customlist.is_open()) //checks if file exists and exits loop if does not
            break;
        newpersonone.loadcustom(newpersonone, customlist); //vector is copy-constructor, only one object needed
    }
}

string functions::customslot(int slotnum) //generates sequential filenames to be converted into c_str for filei/o
{
    stringstream tempfilename;
    tempfilename << "custompeople/customperson" << slotnum << ".txt";
    return tempfilename.str();
}

double functions::visualscaler(double attributevalue, int scaler) //scales values as used by simulation to the range seen by users
{
    double scaledvalue; //this function is necessary because of inversion for the values that range below and above 1 in the mathematical model
    if (attributevalue >= 1)
        scaledvalue = ((attributevalue - 1) * scaler + 10); //scaler different depending on increments of variable
    if (attributevalue < 1)
        scaledvalue = (10 - (((1.0 / attributevalue) - 1) * scaler)); //inversion needed for <1
    return scaledvalue;
}

double functions::programscaler(double attributevalue, double scaler) //scales values as seen by users to the range used by simulation
{
    double scaledvalue; //this function is necessary because of inversion for the values that range below and above 1 in the mathematical model
    if (attributevalue >= 10)
        scaledvalue = (((attributevalue - 10) / scaler) + 1); //scaler different depending on increments of variable
    if (attributevalue < 10)
        scaledvalue = (1 / (((10 - attributevalue) / scaler) + 1)); //inversion needed for <1
    return scaledvalue;
}

double functions::timematefunc(double combinedtimevar) //function used to determine offspring's time delay variables and others
{
    if (combinedtimevar == 1.5 || combinedtimevar == 2.5 || combinedtimevar == 3.5 || combinedtimevar == 4.5) //if average is not int
    {
        if (function.rdmgen(1, time(NULL)) == 0) //equal chance to go up or down by 0.5
            combinedtimevar += 0.5;
        else
            combinedtimevar -= 0.5;
    }
    return combinedtimevar;
}

void functions::clearscreen() //clears screen independent of os
{
    #ifdef __WIN32
    system("cls");
    #endif
    #ifndef __WIN32
    system("clear");
    #endif
}

void functions::renamer(int &slotdeleted) //renames each custom person file to the one which numerically sequentially precedes it
{
    for (int i = slotdeleted; ; i++) //checks which file was deleted to begin the renaming at that number
    {
        ifstream customlist(function.customslot(i + 1).c_str()); //begins with file immediately after one deleted
        if (!customlist.is_open())  //checks if file exists and exits loop if does not
            break;
        customlist.close();
        rename(function.customslot(i + 1).c_str(), function.customslot(i).c_str());
    }
}

double functions::variableboundary(double value, int bound) //ensures values do not go over boundary or below 0
{
    if (value < 0)
        return 0;
    else if (value > bound)
        return bound;
    else
        return value;
}

int functions::crossovermateint(int &crossone, int &crosstwo) //crossover mating algorithm
{
    if (function.rdmgen(1, time(NULL)) == 0)
        return crossone; //returns first parent's attribute
    else
        return crosstwo; //returns second parent's attribute
}

double functions::crossovermate(double &crossone, double &crosstwo) //crossover mating algorithm
{
    if (function.rdmgen(1, time(NULL)) == 0)
        return crossone; //returns first parent's attribute
    else
        return crosstwo; //returns second parent's attribute
}

void functions::introscreen()
{
    cout << "Intro Screen/Explanation" << endl;
    cout << "After first entering the program, these are the choices and what they do:" << endl;
    cout << endl << "1. View Profiles" << endl;
    cout << "Select this to view the attributes and characteristics of all the built-in and custom people." << endl;
    cout << endl << "2. Create Custom Person" << endl;
    cout << "Select this to create your own custom person for use in the interaction simulation." << endl;
    cout << endl << "3. Mate Two People" << endl;
    cout << "Select this to mate two existing people to create a new custom person representing their offspring." << endl;
    cout << endl << "4. Delete Custom Person" << endl;
    cout << "Select this to delete a custom person.  Do not attempt to delete files from the \"custompeople\" folder yourself." << endl;
    cout << endl << "5. Edit Built-In Person" << endl;
    cout << "Select this to temporarily change the gender, age, and name of a built-in person." << endl;
    cout << endl << "6. Begin Simulation" << endl;
    cout << "Select this to begin simulating the social interactions and relationships between two general or specific persons." << endl;
    cout << endl << "10. Leave Program" << endl;
    cout << "Exits the program." << endl;
    cout << endl << "Press return twice to continue.";
    cin.ignore().get();
}

//////////////////////////////////////////////////////////////////////////////
//
//Functions Associated with the Menu Previous to Simulation
//
//////////////////////////////////////////////////////////////////////////////

void functions::menu() //the menu function seen initially
{
    romeo.creator(); //creates all the built-in people
    function.preloader(); //loads all the custom people
    function.introscreen(); //introductory help screen
    for ( ; ; )
    {
        function.clearscreen();
        cout << "Make a choice (type number and hit return):" << endl;
        cout << "1. View Profiles" << endl << "2. Create Custom Person" << endl << "3. Mate Two People" << endl << "4. Delete Custom Person" << endl;
        cout << "5. Edit Built-In Person" << endl << "6. Begin Simulation" << endl << "10. Leave Program" << endl;
        cin >> choice;
        function.clearscreen();
        if (choice == 1) //view profiles selection
        {
            for ( ; ; )
            {
                function.listpeople();
                cout << endl << "View which person's profile? (menu repeats after each viewing; 0 to exit menu)" << endl;
                cin >> choice;
                if (choice == 0)
                    break;
                else
                    newpersonone.profileview(vectorofpeople[choice - 1], &cout); //views selected person
            }
        }
        if (choice == 2) //create custom person selection
        {
            function.listcustompeople();
            cout << endl << "Create using which slot? (0 for none; choosing a slot with a person in it already will overwrite that slot; if using a new/blank slot, use the first empty one available; if this is your first time saving a custom person, use the \"1\" slot)" << endl;
            cin >> choice;
            if (choice != 0)
            {
                if ((choice + 12) < vectorofpeople.size())
                    vectorofpeople.erase(vectorofpeople.begin() + choice + 12);
                ofstream stream(function.customslot(choice).c_str());
                newpersonone.customcreate(stream); //creates person
                ifstream astream(function.customslot(choice).c_str());
                newpersonone.loadcustom(newpersonone, astream); //loads custom person after creation
            }
            choice = 0;
        }
        if (choice == 3)
        {
            for ( ; ; )
            {
                int choicetwo, choicethree; //mate pair selection
                function.listpeople();
                cout << endl << "Select first person to be a parent. (menu repeats after each mating; 0 to exit menu)" << endl;
                cin >> choice;
                if (choice == 0)
                    break;
                cout << "Select second person to be a parent. (menu repeats after each mating; 0 to exit menu)" << endl;
                cin >> choicetwo;
                if (choicetwo == 0)
                    break;
                function.listcustompeople();
                cout << endl << "Select which save slot to save the child to. (0 to exit menu; choosing a slot with a person in it already will overwrite that slot; if using a new/blank slot, use the first empty one available; if this is your first time saving a custom person, use the \"1\" slot)" << endl;
                cin >> choicethree;
                if (choicethree != 0)
                {
                    if ((choicethree + 12) < vectorofpeople.size())
                        vectorofpeople.erase(vectorofpeople.begin() + choicethree + 12);
                    ofstream stream(function.customslot(choicethree).c_str());
                    newpersonone.mate(vectorofpeople[choice - 1], vectorofpeople[choicetwo - 1], stream); //mates person
                    ifstream astream(function.customslot(choicethree).c_str());
                    newpersonone.loadcustom(newpersonone, astream); //loads offspring
                }
            }
            choice = 0;
        }
        if (choice == 4) //delete custom person selection
        {
            for ( ; ; )
            {
                function.listcustompeople();
                cout << endl << "Delete which custom person? (menu repeats after each deletion; 0 for none)" << endl;
                cin >> choice;
                if (choice == 0)
                    break;
                vectorofpeople.erase(vectorofpeople.begin() + choice + 12);
                remove(function.customslot(choice).c_str()); //deletes person
                function.renamer(choice); //moves the custom people after the selection down one each
            }
            choice = 0;
        }
        if (choice == 5) //edit built-in selection
        {
            for ( ; ; )
            {
                function.listpeople();
                cout << endl << "Edit which person's profile? (menu repeats after each edit; 0 to exit menu)" << endl;
                cin >> choice;
                if (choice == 0)
                    break;
                newpersonone.builtinedit(vectorofpeople[choice - 1]); //edits built-in
            }
            choice = 0;
        }
        if (choice == 6) //runs simulation
            function.simulation();
        if (choice == 10) //exits program
            break;
    }
}

void person::profileview(person &viewperson, ostream *out) //views a profile using scaled numbers
{
    if ((*out) == cout) //only when viewing in the program
        (*out) << endl << "Attributes rated from 0 to 20 unless noted otherwise." << endl;
    (*out) << endl << "Name: " << viewperson.name << endl;
    (*out) << "Gender: " << viewperson.gender << endl;
    (*out) << "Humor: " << (viewperson.humor * 10 + 10) << endl;
    (*out) << "Friendliness: " << (viewperson.friendliness * 10 + 10) << endl;
    (*out) << "Kindness: " << (viewperson.kindness * 10 + 10) << endl;
    (*out) << "Active Interests: " << (viewperson.activeinterests * 10 + 10) << endl;
    (*out) << "Charisma: " << (viewperson.charisma * 10 + 10) << endl;
    (*out) << "Quirky: " << (viewperson.quirky * 10 + 10) << endl;
    (*out) << "Social Groups: " << (viewperson.socialgroups * 10 + 10) << endl;
    (*out) << "Altruism: " << (viewperson.altruism * 10 + 10) << endl;
    (*out) << "Education: " << (viewperson.education * 10 + 10) << endl;
    (*out) << "Luck (Randomly Determined During Simulation): " << (viewperson.luck * 10 + 10) << endl;
    (*out) << "Sensitivity: ";
    (*out) << function.visualscaler(viewperson.sensitivity, 20) << endl;
    (*out) << "Selfmotivation: ";
    (*out) << function.visualscaler(viewperson.selfmotivation, 20) << endl;
    (*out) << "Trust/Naivete: ";
    (*out) << function.visualscaler(viewperson.trustnaive, 10) << endl;
    (*out) << "Arrogance: ";
    (*out) << function.visualscaler(viewperson.arrogance, 10) << endl;
    (*out) << "Emotion: ";
    if (viewperson.emotionstoic == 1)
        (*out) << "Yes" << endl;
    if (viewperson.emotionstoic == -1)
        (*out) << "No" << endl;
    (*out) << "Passive Aggressive: ";
    if (viewperson.passiveaggressive == 1)
        (*out) << "No" << endl;
    if (viewperson.passiveaggressive == -1)
        (*out) << "Yes" << endl;
    (*out) << "Perception (1-3, 1:best): " << viewperson.perception << endl;
    (*out) << "Communication (1-3, 1:best): " << viewperson.communication << endl;
    (*out) << "Selfawareness (1-3, 1:best): " << viewperson.selfawareness << endl;
    (*out) << "Appearance: " << (viewperson.appearance * 5 + 10) << endl;
    (*out) << "Wealth: " << (viewperson.wealth * 5 + 10) << endl;
    (*out) << "Adventurous: " << (viewperson.adventurous * 5 + 10) << endl;
    (*out) << "Relationship Maturity: " << (viewperson.relationshipmaturity * 5 + 10) << endl;
    (*out) << "Power: " << (viewperson.power * 5 + 10) << endl;
    (*out) << "Intelligence: " << (viewperson.intell * 5 + 10) << endl;
    (*out) << "Avoid Conflict Probability: " << viewperson.avoidsconflict << "/25" << endl;
    (*out) << "Courage Probability: " << viewperson.courage << "/25" << endl;
    (*out) << "Honesty (0-25): " << viewperson.honesty << endl;
    (*out) << "Age Group (1-5; 1 youngest): " << viewperson.age << endl;
    if ((*out) != cout) //counters for when written out to file
    {
        (*out) << "Avoids Conflict Counter: " << viewperson.avoidcount << endl;
        (*out) << "Courage Counter: " << viewperson.couragecount << endl;
        (*out) << "Despondency Counter: " << viewperson.despondcount << endl;
    }
}

void person::customcreate(ofstream &saveperson) //creates a custom person in a text file in the "custompeople" folder
{
    function.clearscreen();
    double adouble;
    int aint;
    char achar;
    string astring;
    cout << "What is the name of the person? (put a \".\" at the end of the name)" << endl;
    getline(cin, astring, '.');
    saveperson << astring << endl;
    cout << "What is the person's gender? (M/F)" << endl;
    cin >> achar;
    saveperson << achar << endl;
    cout << "Rate the person's sense of humor. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate the person's friendliness. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate the person's kindness. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate the person's participation in activities, hobbies, and interests. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate the person's charisma. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate the person's quirkiness (how appealing the unusual aspects of this person are). (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate this person's diversity of friends and willingness to have different groups of friends. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate this person's sense of altruism. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate this person's level of education. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 10.0) - 1) << endl;
    cout << "Rate this person's sensitivity (the strength of his or her response to how others feel about him or her). (0-20)" << endl;
    cin >> adouble;
    saveperson << function.programscaler(adouble, 20.0) << endl;
    cout << "Rate this person's motivation (the strength of his or her response when acting on how this person feels about others). (0-20)" << endl;
    cin >> adouble;
    saveperson << function.programscaler(adouble, 20.0) << endl;
    cout << "Rate this person's ability to perceive shifts and changes in the mood of others. (1-3, 1:best)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Rate this person's ability to/frequency of communicate(ion) with others. (1-3, 1:best)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Rate this person's ability to be aware of and sense shifts and changes in his or her own feelings. (1-3, 1:best)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Rate this person's level of trust in others/naivete (importance placed on others' feelings over his or her own). (0-20)" << endl;
    cin >> adouble;
    saveperson << function.programscaler(adouble, 10.0) << endl;
    cout << "Rate this person's level of arrogance/egoism (concern for his or her own feelings over others). (0-20)" << endl;
    cin >> adouble;
    saveperson << function.programscaler(adouble, 10.0) << endl;
    cout << "Does this person show emotion or is the person stoic? (1:emotion, -1:stoic)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Does this person reciprocate the feelings of others or behave oppositely? (1:reciprocate,  -1:opposite; listed as \"Passive Aggressive\")" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Rate this person's appearance. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 5.0) - 2) << endl;
    cout << "Rate this person's wealth. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 5.0) - 2) << endl;
    cout << "Rate this person's spirit of adventure. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 5.0) - 2) << endl;
    cout << "Rate this person's maturity in handling relationships. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 5.0) - 2) << endl;
    cout << "Rate this person's power/authority. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 5.0) - 2) << endl;
    cout << "Rate this person's intelligence. (0-20)" << endl;
    cin >> adouble;
    saveperson << ((adouble / 5.0) - 2) << endl;
    cout << "Rate this person's willingness to avoid conflict yet not pursue a positive relationship after reducing the hostility. (0-25)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Rate this person's willingness to have courage and begin responding and/or show initiative romantically when otherwise despondent and/or cautious about the chances of a possible romantic relationship. (0-25)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Rate this person's honesty with others and self. (0-25)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    cout << "Select this person's age group. (1: 15-21, 2: 22-29 3: 30-39 4: 40-49 5: 50+)" << endl;
    cin >> aint;
    saveperson << aint << endl;
    saveperson.close();
}

void person::mate(person &mateone, person &matetwo, ofstream &baby) //mates two people via a knockoff GA and saves the offspring in the "custompeople" folder
{
    function.clearscreen(); //the function averages some values together with a slight genetic mutation afterward because not all
    string astring; //aggregate crossovers result in 50/50 allele dominance; some values are averaged after visualscaling and then programscaled; this is because of the math involved
    cout << "Everything after choosing the name of the child is fully automated.  You can view the child immediately after entering the name." << endl;
    cout << "What is the name of the child? (put a \".\" at the end of the name)" << endl;
    getline (cin, astring, '.');
    baby << astring << endl;
    if (function.rdmgen(1, time(NULL)) == 0) //random gender
        baby << 'M' << endl;
    else
        baby << 'F' << endl; //there is also some crossover for attributes where the offspring is more likely to only take after one parent
    baby << function.crossovermate(mateone.humor, matetwo.humor) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << function.crossovermate(mateone.friendliness, matetwo.friendliness) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << function.crossovermate(mateone.kindness, matetwo.kindness) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << ((mateone.activeinterests + matetwo.activeinterests) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << function.crossovermate(mateone.charisma, matetwo.charisma) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << ((mateone.quirky + matetwo.quirky) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << ((mateone.socialgroups + matetwo.socialgroups) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << function.crossovermate(mateone.altruism, matetwo.altruism) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << ((mateone.education + matetwo.education) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 10.0) << endl;
    baby << function.programscaler(function.visualscaler(function.crossovermate(mateone.sensitivity, matetwo.sensitivity), 20) + ((function.rdmgen(4, time(NULL))) - 2), 20.0) << endl;
    baby << function.programscaler(function.visualscaler(function.crossovermate(mateone.selfmotivation, matetwo.selfmotivation), 20) + ((function.rdmgen(4, time(NULL))) - 2), 20.0) << endl;
    //above two: crossover between sensitivity/selfmotivation, scale visually and add genetic mutation, scale back to program values
    baby << function.timematefunc((mateone.perception + matetwo.perception) / 2.0) << endl;
    baby << function.timematefunc((mateone.communication + matetwo.communication) / 2.0) << endl;
    baby << function.timematefunc((mateone.selfawareness + matetwo.selfawareness) / 2.0) << endl;
    baby << function.programscaler(function.visualscaler(function.crossovermate(mateone.trustnaive, matetwo.trustnaive), 20) + ((function.rdmgen(4, time(NULL))) - 2), 20.0) << endl;
    baby << function.programscaler(function.visualscaler(function.crossovermate(mateone.arrogance, matetwo.arrogance), 20) + ((function.rdmgen(4, time(NULL))) - 2), 20.0) << endl;
    //see above comment
    baby << function.crossovermateint(mateone.emotionstoic, matetwo.emotionstoic) << endl;
    baby << function.crossovermateint(mateone.passiveaggressive, matetwo.passiveaggressive) << endl;
    baby << ((mateone.appearance + matetwo.appearance) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 5.0) << endl;
    baby << ((mateone.wealth + matetwo.wealth) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 5.0) << endl;
    baby << function.crossovermate(mateone.adventurous, matetwo.adventurous) + (((function.rdmgen(4, time(NULL))) - 2) / 5.0) << endl;
    baby << function.crossovermate(mateone.relationshipmaturity, matetwo.relationshipmaturity) + (((function.rdmgen(4, time(NULL))) - 2) / 5.0) << endl;
    baby << ((mateone.power + matetwo.power) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 5.0) << endl;
    baby << ((mateone.intell + matetwo.intell) / 2.0) + (((function.rdmgen(4, time(NULL))) - 2) / 5.0) << endl;
    baby << function.variableboundary(function.crossovermateint(mateone.avoidsconflict, matetwo.avoidsconflict) + (function.rdmgen(4, time(NULL)) - 2), 25) << endl;
    baby << function.variableboundary(function.crossovermateint(mateone.courage, matetwo.courage) + (function.rdmgen(4, time(NULL)) - 2), 25) << endl;
    baby << floor(function.variableboundary(((mateone.honesty + matetwo.honesty) / 2.0) + (function.rdmgen(5, time(NULL)) - 2), 25)) << endl;//rdm is the way it is because .5 will be rounded down and so balancing was needed
    baby << function.rdmgen(4, time(NULL)) + 1 << endl;
}

void person::loadcustom(person &persontoload, ifstream &loadperson) //loads a custom person from the "custompeople" folder
{
    double adouble; //this is called after creating or mating a person and at the beginning of the program
    int aint;
    char achar;
    string astring;
    getline(loadperson, astring, '\n'); //blank line at beginning of file when using getline for ofstream
    getline(loadperson, astring, '\n');
    persontoload.name = astring;
    loadperson >> achar;
    persontoload.gender = achar;
    loadperson >> adouble;
    persontoload.humor = adouble;
    loadperson >> adouble;
    persontoload.friendliness = adouble;
    loadperson >> adouble;
    persontoload.kindness = adouble;
    loadperson >> adouble;
    persontoload.activeinterests = adouble;
    loadperson >> adouble;
    persontoload.charisma = adouble;
    loadperson >> adouble;
    persontoload.quirky = adouble;
    loadperson >> adouble;
    persontoload.socialgroups = adouble;
    loadperson >> adouble;
    persontoload.altruism = adouble;
    loadperson >> adouble;
    persontoload.education = adouble;
    loadperson >> adouble;
    persontoload.sensitivity = adouble;
    loadperson >> adouble;
    persontoload.selfmotivation = adouble;
    loadperson >> aint;
    persontoload.perception = aint;
    loadperson >> aint;
    persontoload.communication = aint;
    loadperson >> aint;
    persontoload.selfawareness = aint;
    loadperson >> adouble;
    persontoload.trustnaive = adouble;
    loadperson >> adouble;
    persontoload.arrogance = adouble;
    loadperson >> aint;
    persontoload.emotionstoic = aint;
    loadperson >> aint;
    persontoload.passiveaggressive = aint;
    loadperson >> adouble;
    persontoload.appearance = adouble;
    loadperson >> adouble;
    persontoload.wealth = adouble;
    loadperson >> adouble;
    persontoload.adventurous = adouble;
    loadperson >> adouble;
    persontoload.relationshipmaturity = adouble;
    loadperson >> adouble;
    persontoload.power = adouble;
    loadperson >> adouble;
    persontoload.intell = adouble;
    loadperson >> aint;
    persontoload.avoidsconflict = aint;
    loadperson >> aint;
    persontoload.courage = aint;
    loadperson >> aint;
    persontoload.honesty = aint;
    loadperson >> aint;
    persontoload.age = aint;
    loadperson.close();
    persontoload.love = false;
    persontoload.hate = false;
    vectorofpeople.push_back(persontoload); //vector is copy-constructor, only one object needed
}

void person::builtinedit(person personedit) //temporarily alters gender and age of built-in person
{
    char gender;
    int age;
    string astring;
    function.clearscreen();
    cout << "Here you can edit a person's gender and age, but these changes will not be stored for the next time you run the program." << endl;
    cout << "A temporary, edited version of the person will be added to the list of available people until you exit the program." << endl;
    cout << "If you want to permanently edit a custom person's age (perhaps because he/she is an offspring), simply edit the last line of the corresponding text file." << endl;
    cout << "If you want to permanently edit a custom person's gender (again because he/she is an offspring), simply edit the second line of the corresponding text file." << endl;
    cout << endl << "What is " << personedit.name << "'s new gender? (current gender is: " << personedit.gender << ")" << endl;
    cin >> gender;
    personedit.gender = gender;
    cout << "What is " << personedit.name << "'s new age group? (current age group is: " << personedit.age << ")" << endl;
    cout << "Reminder: age groups are 1: 15-21, 2: 22-29 3: 30-39 4: 40-49 5: 50+" << endl;
    cin >> age;
    personedit.age = age;
    cout << "What would you like to name the edited version of this person? (put a \".\" at the end of the name)" << endl;
    getline(cin, astring, '.');
    astring.erase(0, 1); //deletes the newline at the beginning of the string
    personedit.name = astring;
    vectorofpeople.push_back(personedit); //adds edited built-in person
}

//////////////////////////////////////////////////////////////////////////////
//
//Functions Associated with the Actual Simulation
//
//////////////////////////////////////////////////////////////////////////////

void functions::simulation() //menu precursor to running the simulation
{
    int choicetwo;
    function.clearscreen();
    function.listpeople();
    cout << endl << "Is the pair:" << endl << "1. two general types or categories of persons interacting many times with variations (example: Introvert, Extrovert, Narcissist)" << endl << "2. two specific or real world persons interacting once (example: you, your family members)" << endl;
    cout << "(0 to quit simulation and return to menu; input junk numbers for next two choices if quitting simulation)" << endl;
    cin >> choicetwo;
    cout << "Who is the first person to test interactions with?" << endl;
    cin >> choice;
    person personone = vectorofpeople[choice - 1];
    if (choicetwo == 1)
        function.genderbias(personone); //genderbias is applied before all other varying factors and only if general interactions
    cout << "Who is the second person to test interactions with?" << endl;
    cin >> choice;
    person persontwo = vectorofpeople[choice - 1];
    if (choicetwo == 1)
        function.genderbias(persontwo); //genderbias is applied before all other varying factors and only if general interactions
    if (choicetwo == 1) //only remove phase space outputs if general interaction is chosen
    {
        remove(("generated data/" + personone.name + persontwo.name + " firstrun.txt").c_str());
        remove(("generated data/" + personone.name + persontwo.name + " mutuallove.txt").c_str());
        remove(("generated data/" + personone.name + persontwo.name + " mutualhate.txt").c_str());
        remove(("generated data/" + personone.name + persontwo.name + " lovehate.txt").c_str());
        remove(("generated data/" + personone.name + persontwo.name + " hatelove.txt").c_str());
        remove(("generated data/" + personone.name + persontwo.name + " mutualapathy.txt").c_str());
    }
    if (choicetwo == 1)
        function.interaction(personone, persontwo); //variations on types of two persons
    if (choicetwo == 2)
        function.specificinteraction(personone, persontwo); //two specific persons
}

void functions::interaction(person &personfirst, person &personsecond) //function for interactions between two types of persons
{
    double outputone[21], outputtwo[21]; //for phase space output
    double totalfeelingsone[10000], totalfeelingstwo[10000]; //for distribution output of feelings
    person restorerone = personfirst, restorertwo = personsecond; //to restore each type of person to pre-variation values
    for(int i = 0; i < 10000; i++) //loops interactions for 10000 slightly altered people, each time with a new RNG seed
    {
        personfirst = restorerone; //remove variations
        personsecond = restorertwo;
        function.peoplevariations(personfirst); //slight genetic variations
        function.peoplevariations(personsecond);
        double a = (personfirst.emotionstoic * personfirst.arrogance * (1.0 / personfirst.trustnaive)), b = (personfirst.emotionstoic * personfirst.selfmotivation);
        double c = (personfirst.passiveaggressive * (1.0 / personfirst.arrogance) * personfirst.trustnaive), d = (personfirst.passiveaggressive * personfirst.sensitivity);
        double e = (personsecond.passiveaggressive * (1.0 / personsecond.arrogance) * personsecond.trustnaive), f = (personsecond.passiveaggressive * personsecond.sensitivity);
        double g = (personsecond.emotionstoic * personsecond.arrogance * (1.0 / personsecond.trustnaive)), h = (personsecond.emotionstoic * personsecond.selfmotivation);
        int k = personfirst.selfawareness, l = (personfirst.perception + personsecond.communication), m = (personsecond.perception + personfirst.communication), n = personsecond.selfawareness;
        //R_t = (aR + bR|R| + cJ + dJ|J|) <--- R_t-k J_t-l RHS  variables calculated and initialized above
        //J_t = (eR + fR|R| + gJ + hJ|J|) <--- R_t-m J_t-n RHS
        double initfirst, initsecond; //initial feelings/first impression
        function.rngcarelevel(personfirst, personsecond, initfirst); //subjective evaluation of initial feelings/first impression
        function.rngcarelevel(personsecond, personfirst, initsecond);
        double firstfeelings[8] = {initfirst, initfirst, initfirst, initfirst, initfirst, initfirst, initfirst, initfirst};
        double secondfeelings[8] = {initsecond, initsecond, initsecond, initsecond, initsecond, initsecond, initsecond, initsecond};
        bool timeevolve = false; //to prevent doing perception/communication bonus more than once
        function.lovehatecheck(personfirst, personsecond, initfirst); //subjective evaluation on whether the love/hate "kickover" is reached
        function.lovehatecheck(personsecond, personfirst, initsecond);
        for (int ii = 0; ii < 20; ii++) //20 is number of steps per person
        {
            for (int iii = 6; iii >= 0; iii--) //each feelings value is set backward one timestep in the array
            {
                firstfeelings[iii + 1] = firstfeelings[iii];
                secondfeelings[iii + 1] = secondfeelings[iii];
            } //calculate feelings below during each step
            if (l == 0)
            {
                secondfeelings[0] = (e * firstfeelings[m]) + (f * firstfeelings[m] * abs(firstfeelings[m])) + (g * secondfeelings[n]) + (h * secondfeelings[n] * abs(secondfeelings[n]));
                secondfeelings[0] = function.feelingsscaler(secondfeelings[0]); //apply logarithmic scaling immediately
                firstfeelings[0] = (a * firstfeelings[k]) + (b * firstfeelings[k] * abs(firstfeelings[k])) + (c * secondfeelings[l]) + (d * secondfeelings[l] * abs(secondfeelings[l]));
                firstfeelings[0] = function.feelingsscaler(firstfeelings[0]);
            }
            else
            {
                firstfeelings[0] = (a * firstfeelings[k]) + (b * firstfeelings[k] * abs(firstfeelings[k])) + (c * secondfeelings[l]) + (d * secondfeelings[l] * abs(secondfeelings[l]));
                firstfeelings[0] = function.feelingsscaler(firstfeelings[0]); //apply logarithmic scaling immediately
                secondfeelings[0] = (e * firstfeelings[m]) + (f * firstfeelings[m] * abs(firstfeelings[m])) + (g * secondfeelings[n]) + (h * secondfeelings[n] * abs(secondfeelings[n]));
                secondfeelings[0] = function.feelingsscaler(secondfeelings[0]);
            }
            if (ii == 3 || ii == 7 || ii == 11 || ii == 15) //check for coefficient evolution feedback loops
                function.coefficientevolution(a, b, g, h, l, m, firstfeelings[0], secondfeelings[0], personfirst, personsecond, timeevolve);
            if (ii == 0)
            {
                outputone[0] = firstfeelings[1];
                outputtwo[0] = secondfeelings[1];
            }
            outputone[ii+1] = firstfeelings[0]; //storing for phase space output; performed before honesty variability
            outputtwo[ii+1] = secondfeelings[0];
            if (ii < 19) //honesty variability; skipped for final step because there is no step afterward
            {
                firstfeelings[0] += ((function.rdmgen(20, time(NULL)) - 10) / 10.0) * ((25 - personfirst.honesty) / 25.0);
                secondfeelings[0] += ((function.rdmgen(20, time(NULL)) - 10) / 10.0) * ((25 - personsecond.honesty) / 25.0);
            }
        }
        if (i == 0) //first run phase space output
            function.phasespaceoutput(personfirst, personsecond, outputone, outputtwo, true, firstfeelings[0], secondfeelings[0], timeevolve, false);
        function.phasespaceoutput(personfirst, personsecond, outputone, outputtwo, false, firstfeelings[0], secondfeelings[0], timeevolve, false); //special conditions phase space output
        totalfeelingsone[i] = firstfeelings[0]; //storing for distribution output
        totalfeelingstwo[i] = secondfeelings[0];
        function.tabulator(firstfeelings[0], personfirst, restorerone); //tab up total feelings and love/hate count
        function.tabulator(secondfeelings[0], personsecond, restorertwo);
    }
    string distfilename = "generated data/" + personfirst.name + personsecond.name + " distributionoutput.txt";
    ofstream astream(distfilename.c_str()); //output final feelings of each run
    for (int i = 0; i < 10000; i++)
    {
        astream << totalfeelingsone[i] << '\t' << totalfeelingstwo[i] << endl;
    }
    astream.close();
    cout << "Press return to continue to the results screen." << endl; //waits for user to view displayed messages before showing results
    cin.ignore().get();
    function.results(restorerone, restorertwo, 10000.0); //display simple summary of simulation with non-varied persons
}

void functions::specificinteraction(person &personfirst, person &personsecond) //function for interaction between two specific persons
{
    double outputone[21], outputtwo[21]; //see above function for specifics on everything here; some stuff not needed and therefore removed
    double a = (personfirst.emotionstoic * personfirst.arrogance * (1.0 / personfirst.trustnaive)), b = (personfirst.emotionstoic * personfirst.selfmotivation);
    double c = (personfirst.passiveaggressive * (1.0 / personfirst.arrogance) * personfirst.trustnaive), d = (personfirst.passiveaggressive * personfirst.sensitivity);
    double e = (personsecond.passiveaggressive * (1.0 / personsecond.arrogance) * personsecond.trustnaive), f = (personsecond.passiveaggressive * personsecond.sensitivity);
    double g = (personsecond.emotionstoic * personsecond.arrogance * (1.0 / personsecond.trustnaive)), h = (personsecond.emotionstoic * personsecond.selfmotivation);
    int k = personfirst.selfawareness, l = (personfirst.perception + personsecond.communication), m = (personsecond.perception + personfirst.communication), n = personsecond.selfawareness;
    double initfirst, initsecond;
    function.specificcarelevel(personfirst, personsecond, initfirst); //subjective evaluation of initial feelings manually inputted
    function.specificcarelevel(personsecond, personfirst, initsecond);
    double firstfeelings[8] = {initfirst, initfirst, initfirst, initfirst, initfirst, initfirst, initfirst, initfirst};
    double secondfeelings[8] = {initsecond, initsecond, initsecond, initsecond, initsecond, initsecond, initsecond, initsecond};
    bool timeevolve = false;
    function.speclovehate(personfirst, personsecond, initfirst); //subjective evaluation of threshold variables manually inputted
    function.speclovehate(personsecond, personfirst, initsecond);
    for (int ii = 0; ii < 20; ii++)
    {
        for (int iii = 6; iii >= 0; iii--)
        {
            firstfeelings[iii + 1] = firstfeelings[iii];
            secondfeelings[iii + 1] = secondfeelings[iii];
        }
        if (l == 0)
        {
            secondfeelings[0] = (e * firstfeelings[m]) + (f * firstfeelings[m] * abs(firstfeelings[m])) + (g * secondfeelings[n]) + (h * secondfeelings[n] * abs(secondfeelings[n]));
            secondfeelings[0] = function.feelingsscaler(secondfeelings[0]);
            firstfeelings[0] = (a * firstfeelings[k]) + (b * firstfeelings[k] * abs(firstfeelings[k])) + (c * secondfeelings[l]) + (d * secondfeelings[l] * abs(secondfeelings[l]));
            firstfeelings[0] = function.feelingsscaler(firstfeelings[0]);
        }
        else
        {
            firstfeelings[0] = (a * firstfeelings[k]) + (b * firstfeelings[k] * abs(firstfeelings[k])) + (c * secondfeelings[l]) + (d * secondfeelings[l] * abs(secondfeelings[l]));
            firstfeelings[0] = function.feelingsscaler(firstfeelings[0]);
            secondfeelings[0] = (e * firstfeelings[m]) + (f * firstfeelings[m] * abs(firstfeelings[m])) + (g * secondfeelings[n]) + (h * secondfeelings[n] * abs(secondfeelings[n]));
            secondfeelings[0] = function.feelingsscaler(secondfeelings[0]);
        }
        if (ii == 3 || ii == 7 || ii == 11 || ii == 15)
            function.coefficientevolution(a, b, g, h, l, m, firstfeelings[0], secondfeelings[0], personfirst, personsecond, timeevolve);
        if (ii == 0)
        {
            outputone[0] = firstfeelings[1];
            outputtwo[0] = secondfeelings[1];
        }
        outputone[ii+1] = firstfeelings[0];
        outputtwo[ii+1] = secondfeelings[0];
        if (ii < 19)
        {
            firstfeelings[0] += ((function.rdmgen(20, time(NULL)) - 10) / 20.0) * ((25 - personfirst.honesty) / 25.0);
            secondfeelings[0] += ((function.rdmgen(20, time(NULL)) - 10) / 20.0) * ((25 - personsecond.honesty) / 25.0);
        }
    }
    function.tabulator(firstfeelings[0], personfirst, personfirst);
    function.tabulator(secondfeelings[0], personsecond, personsecond);
    function.phasespaceoutput(personfirst, personsecond, outputone, outputtwo, true, firstfeelings[0], secondfeelings[0], timeevolve, true);
    function.results(personfirst, personsecond, 1.0);
    function.aiextra(firstfeelings, secondfeelings, personfirst, personsecond, a, b, c, d, e, f, g, h, k, l, m, n); //ai simulation afterwards
}

void functions::aiextra(double aifeelone[], double aifeeltwo[], person &aione, person &aitwo, double &aa, double &bb, double &cc, double &dd, double &ee, double &ff, double &gg, double &hh, int &kk, int &ll, int &mm, int &nn)
{//extra bit of manually-induced feedback loop for specific interactions
    function.clearscreen();
    cout << "Pseudo-AI Extra Simulation: begins where the automated portion left off.  Twenty more steps, with no automated feedback loops (except for intoxication which induces the courage one), will be run." << endl << endl;
    cout << "Make a choice:" << endl << "1. " << aione.name << " dies" << endl << "2. " << aitwo.name << " dies" << endl << "3. " << aione.name << " cheats" << endl << "4. " << aitwo.name << " cheats" << endl;
    cout << "5. " << aione.name << " becomes intoxicated" << endl << "6. " << aitwo.name << " becomes intoxicated" << endl;
    cin >> choice;
    if (choice == 1)
        aifeelone[0] = aa = bb = cc = dd = ff = 0; //remove first person's influence on feelings
    if (choice == 2)
        aifeeltwo[0] = ee = ff = gg = hh = cc = 0; //remove second person's influence on feelings
    if (choice == 3)
    { //provoke negative reaction and decrease in trust by second person
        aifeeltwo[0] = -3.5;
        aifeeltwo[1] = -3.5;
        aifeeltwo[2] = -3.5;
        ee = 0.25;
    }
    if (choice == 4)
    { //provoke negative reaction and decrease in trust by first person
        aifeelone[0] = -3.5;
        aifeelone[1] = -3.5;
        aifeelone[2] = -3.5;
        cc = 0.25;
    }
    if (choice == 5)
    { //bonus to courage of first and appearance of second; redo lovehatecheck if necessary and redo courage feedback loop
        aione.courage = function.variableboundary(aione.courage + 10, 25);
        aione.intell -= 1;
        aitwo.appearance += 1;
        if (aione.love == false)
            function.lovehatecheck(aione, aitwo, aifeelone[0]);
        if (aa < 0 && aifeeltwo[0] > 3.3 && aione.love == true && aione.courage >= function.rdmgen(25, time(NULL))) //courage
        {
            aa *= -1;
            bb *= -1;
        }
    }
    if (choice == 6)
    { //bonus to courage of second and appearance of first; redo lovehatecheck if necessary and redo courage feedback loop
        aitwo.courage = function.variableboundary(aitwo.courage + 10, 25);
        aitwo.intell -= 1;
        aione.appearance += 1;
        if (aitwo.love == false)
            function.lovehatecheck(aitwo, aione, aifeeltwo[0]);
        if (gg < 0 && aifeelone[0] > 3.3 && aitwo.love == true && aitwo.courage >= function.rdmgen(25, time(NULL)))
        {
            gg *= -1;
            hh *= -1;
        }
    }
    for (int ii = 0; ii < 20; ii++) //20 more steps
    {
        for (int iii = 6; iii >= 0; iii--)
        {
            aifeelone[iii + 1] = aifeelone[iii];
            aifeeltwo[iii + 1] = aifeeltwo[iii];
        }
        aifeelone[0] = (aa * aifeelone[kk]) + (bb * aifeelone[kk] * abs(aifeelone[kk])) + (cc * aifeeltwo[ll]) + (dd * aifeeltwo[ll] * abs(aifeeltwo[ll]));
        aifeeltwo[0] = (ee * aifeelone[mm]) + (ff * aifeelone[mm] * abs(aifeelone[mm])) + (gg * aifeeltwo[nn]) + (hh * aifeeltwo[nn] * abs(aifeeltwo[nn]));
        aifeelone[0] = function.feelingsscaler(aifeelone[0]);
        aifeeltwo[0] = function.feelingsscaler(aifeeltwo[0]);
        cout << aione.name << "'s Feelings: " << aifeelone[0] << endl << aitwo.name << "'s Feelings: " << aifeeltwo[0] << endl; //cout output to view in program
        if (ii < 19)
        {
            aifeelone[0] += ((function.rdmgen(20, time(NULL)) - 10) / 20.0) * ((25 - aione.honesty) / 25.0);
            aifeeltwo[0] += ((function.rdmgen(20, time(NULL)) - 10) / 20.0) * ((25 - aitwo.honesty) / 25.0);
        }
    }
    if (aifeelone[0] > 3.6 && aione.love == true)
        cout << endl << aione.name << " loves " << aitwo.name << endl;
    if (aifeeltwo[0] > 3.6 && aitwo.love == true)
        cout << endl << aitwo.name << " loves " << aione.name << endl;
    cout << endl << "Press return to continue." << endl;
    cin.ignore().get();
}

void functions::genderbias(person &theperson) //applies variations based on gender strengths/weaknesses; two identical people with
{//different genders will become different because of this
    if (theperson.gender == 'M' || theperson.gender == 'm')
    {
        theperson.sensitivity *= (9.5 / 10.0);
        theperson.selfmotivation *= (10.0 / 9.5);
        theperson.trustnaive *= (9.5 / 10.0);
        theperson.arrogance *= (10.0 / 9.5);
        theperson.avoidsconflict = function.variableboundary(theperson.avoidsconflict + 2, 25);
        theperson.honesty = function.variableboundary(theperson.honesty + 1, 25);
    }
    if (theperson.gender == 'F' || theperson.gender == 'f')
    {
        theperson.sensitivity *= (10.0 / 9.5);
        theperson.perception -= 1;
        theperson.communication += 1;
        theperson.selfmotivation *= (9.5 / 10.0);
        theperson.trustnaive *= (10.0 / 9.5);
        theperson.arrogance *= (9.5 / 10.0);
        theperson.avoidsconflict = function.variableboundary(theperson.avoidsconflict - 2, 25);
        theperson.honesty = function.variableboundary(theperson.honesty - 1, 25);
    }
    theperson.luck = ((function.rdmgen(20, time(NULL)) / 10.0) - 1); //only reaosnable place to do luck
}

void functions::peoplevariations(person &aperson) //applies slight variations to each type of person during each run
{
    aperson.humor += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.friendliness += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.kindness += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.activeinterests += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.charisma += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.quirky += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.socialgroups += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.altruism += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.education += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.luck += ((function.rdmgen(4, time(NULL)) - 2) / 10.0);
    aperson.appearance += ((function.rdmgen(4, time(NULL)) - 2) / 5.0);
    aperson.wealth += ((function.rdmgen(4, time(NULL)) - 2) / 5.0);
    aperson.adventurous += ((function.rdmgen(4, time(NULL)) - 2) / 5.0);
    aperson.relationshipmaturity += ((function.rdmgen(4, time(NULL)) - 2) / 5.0);
    aperson.power += ((function.rdmgen(4, time(NULL)) - 2) / 5.0);
    aperson.intell += ((function.rdmgen(4, time(NULL)) - 2) / 5.0);
    aperson.avoidsconflict += (function.rdmgen(6, time(NULL)) - 3);
    aperson.courage += (function.rdmgen(6, time(NULL)) - 3);
    aperson.honesty += (function.rdmgen(6, time(NULL)) - 3);
}

void functions::lovehatecheck(person &onecheck, person &twocheck, double initone) //evaluates whether two people have the non-numeric love/hate trigger
{
    double onelovecalc = initone + function.rdmgen(6, time(NULL)); //age and gender are factors in subjective evaluations; the RNG on this line is for random/unique/uncategorized/unknown factors
    if (onecheck.gender == 'M' || onecheck.gender == 'm') //the RNG is for level of caring about each quality each time; difference calculation in variables is to emphasize likelihood of people with similar qualities (e.g. appearance)
        onelovecalc += 4 * (1 + ((3 - onecheck.age) / 5.0)) * ((function.rdmgen(20, time(NULL))) / 10.0) * (1.0 - abs(onecheck.appearance - twocheck.appearance));
    if (onecheck.gender == 'F' || onecheck.gender == 'f')
        onelovecalc += 2 * (1 + ((3 - onecheck.age) / 5.0)) * ((function.rdmgen(20, time(NULL))) / 10.0) * (1.0 - abs(onecheck.appearance - twocheck.appearance));
    if (onecheck.gender == 'M' || onecheck.gender == 'm')
        onelovecalc += 2 * (1 + ((3 - onecheck.age) / 5.0)) * ((function.rdmgen(20, time(NULL))) / 10.0) * twocheck.wealth;
    if (onecheck.gender == 'F' || onecheck.gender == 'f')
        onelovecalc += 4 * (1 + ((3 - onecheck.age) / 5.0)) * ((function.rdmgen(20, time(NULL))) / 10.0) * twocheck.wealth;
    onelovecalc += 3 * ((function.rdmgen(20, time(NULL))) / 10.0) * (1.0 - abs(onecheck.adventurous - twocheck.adventurous));
    onelovecalc += 3 * ((function.rdmgen(20, time(NULL))) / 10.0) * twocheck.power;
    onelovecalc += 3 * (1 + ((onecheck.age - 3) / 5.0)) * ((function.rdmgen(20, time(NULL))) / 10.0) * (1.0 - abs(onecheck.intell - twocheck.intell));
    onelovecalc += 3 * (1 + ((onecheck.age - 3) / 5.0)) * onecheck.relationshipmaturity;
    if (onelovecalc > 15)
        onecheck.love = true;
    onecheck.hate = true; //always triggered due to not sure how to calculate this
}

void functions::speclovehate(person &speclhone, person &speclhtwo, double &speclhinit) //manual input of care level; takes place of RNG in function above
{
    double lovecalc = speclhinit, userinput;
    cout << "Rate the intangible, not easily categorized, or otherwise unique preferences of " << speclhone.name << " and/or unique qualities that ";
    cout << speclhtwo.name << " possesses which make " << speclhone.name << " attracted to " << speclhtwo.name << " romantically. (0-6)" << endl;
    cin >> userinput;
    lovecalc += userinput;
    cout << "Rate how much " << speclhone.name << " cares about appearance in a partner. (0-20)" << endl;
    cin >> userinput;
    if (speclhone.gender == 'M' || speclhone.gender == 'm')
        lovecalc += 4 * (1 + ((3 - speclhone.age) / 5.0)) * (userinput / 10.0) * (1.0 - abs(speclhone.appearance - speclhtwo.appearance));
    if (speclhone.gender == 'F' || speclhone.gender == 'f')
        lovecalc += 2 * (1 + ((3 - speclhone.age) / 5.0)) * (userinput / 10.0) * (1.0 - abs(speclhone.appearance - speclhtwo.appearance));
    cout << "Rate how much " << speclhone.name << " cares about the wealth of a partner. (0-20)" << endl;
    cin >> userinput;
    if (speclhone.gender == 'M' || speclhone.gender == 'm')
        lovecalc += 2 * (1 + ((3 - speclhone.age) / 5.0)) * (userinput / 10.0) * speclhtwo.wealth;
    if (speclhone.gender == 'F' || speclhone.gender == 'f')
        lovecalc += 4 * (1 + ((3 - speclhone.age) / 5.0)) * (userinput / 10.0) * speclhtwo.wealth;
    cout << "Rate how much " << speclhone.name << " cares about adventurous qualities in a partner. (0-20)" << endl;
    cin >> userinput;
    lovecalc += 3 * (userinput / 10.0) * (1.0 - abs(speclhone.adventurous - speclhtwo.adventurous));
    cout << "Rate how much " << speclhone.name << " cares about power and authority in a partner. (0-20)" << endl;
    cin >> userinput;
    lovecalc += 3 * (userinput / 10.0) * speclhtwo.power;
    cout << "Rate how much " << speclhone.name << " cares about intelligence in a partner. (0-20)" << endl;
    cin >> userinput;
    lovecalc += 3 * (1 + ((speclhone.age - 3) / 5.0)) * (userinput / 10.0) * (1.0 - abs(speclhone.intell - speclhtwo.intell));
    lovecalc += 3 * (1 + ((speclhone.age - 3) / 5.0)) * speclhone.relationshipmaturity;
    if (lovecalc > 15)
        speclhone.love = true;
    speclhone.hate = true;
}

double functions::feelingsscaler(double feel) //logarithmic scaling of feelings
{
    if (feel >= 0)
        return log(feel + 1);
    if (feel < 0)
        return -log(abs(feel) + 1);
}

void functions::rngcarelevel(person &carelevelone, person &careleveltwo, double &weightedinitone) //subjective evaluation of initial feelings/first impression
{//RNG is for changes in carelevel; difference calculation is because people seek those of similar qualities in those instances
    weightedinitone = ((function.rdmgen(20, time(NULL))) / 10.0) * careleveltwo.humor;
    weightedinitone += ((function.rdmgen(20, time(NULL))) / 10.0) * careleveltwo.friendliness;
    weightedinitone += ((function.rdmgen(20, time(NULL))) / 10.0) * careleveltwo.kindness;
    weightedinitone += 0.5 - abs(carelevelone.activeinterests - careleveltwo.activeinterests);
    weightedinitone += ((function.rdmgen(20, time(NULL))) / 10.0) * careleveltwo.charisma;
    weightedinitone += 0.5 - abs(carelevelone.quirky - careleveltwo.quirky);
    weightedinitone += careleveltwo.socialgroups;
    weightedinitone += ((function.rdmgen(20, time(NULL))) / 10.0) * careleveltwo.altruism;
    weightedinitone += 0.5 - abs(carelevelone.education - careleveltwo.education);
    weightedinitone += careleveltwo.luck;
}

void functions::specificcarelevel(person &specone, person &spectwo, double &specinitfeel) //manual input of care level; takes place of RNG in function above
{
    double userinput;
    cout << "Rate how much " << specone.name << " cares about humor in others. (0-20)" << endl;
    cin >> userinput;
    specinitfeel = (userinput / 10.0) * spectwo.humor;
    cout << "Rate how much " << specone.name << " cares about friendliness in others. (0-20)" << endl;
    cin >> userinput;
    specinitfeel += (userinput / 10.0) * spectwo.friendliness;
    cout << "Rate how much " << specone.name << " cares about kindness in others. (0-20)" << endl;
    cin >> userinput;
    specinitfeel += (userinput / 10.0) * spectwo.kindness;
    specinitfeel += 0.5 - abs(specone.activeinterests - spectwo.activeinterests);
    cout << "Rate how much " << specone.name << " cares about charisma in others. (0-20)" << endl;
    cin >> userinput;
    specinitfeel += (userinput / 10.0) * spectwo.charisma;
    specinitfeel += 0.5 - abs(specone.quirky - spectwo.quirky);
    specinitfeel += spectwo.socialgroups;
    cout << "Rate how much " << specone.name << " cares about altruism in others. (0-20)" << endl;
    cin >> userinput;
    specinitfeel += (userinput / 10.0) * spectwo.altruism;
    specinitfeel += 0.5 - abs(specone.education - spectwo.education);
    specinitfeel += spectwo.luck;
}

void functions::coefficientevolution(double &aa, double &bb, double &gg, double &hh, int &ll, int &mm, double &feelone, double &feeltwo, person &firstalter, person &secondalter, bool &atimeevolve)
{//cofficient changes via and causing feedback loops
    if (feelone > 0 && feeltwo < 0 && firstalter.avoidsconflict >= function.rdmgen(25, time(NULL))) //avoidsconflict
    {
        feeltwo += feelone;
        feelone /= 4;
    }
    if (feeltwo > 0 && feelone < 0 && secondalter.avoidsconflict >= function.rdmgen(25, time(NULL)))
    {
        feelone += feeltwo;
        feeltwo /= 4;
    }
    if (feelone > 3.3 && feeltwo > 3.3 && atimeevolve == false) //enhanced communication/perception between two people
    {
        ll -= 1;
        mm -= 1;
        atimeevolve = true;
    }
    if (aa < 0 && feeltwo > 3 && firstalter.love == true && firstalter.courage >= function.rdmgen(25, time(NULL))) //courage
    {
        aa *= -1;
        bb *= -1;
    }
    if (gg < 0 && feelone > 3 && secondalter.love == true && secondalter.courage >= function.rdmgen(25, time(NULL)))
    {
        gg *= -1;
        hh *= -1;
    }
    if (aa > 0 && abs(feeltwo) < 1 && firstalter.love == true && firstalter.courage <= function.rdmgen(25, time(NULL))) //despondency
    {
        aa *= -1;
        bb *= -1;
    }
    if (gg > 0 && abs(feelone) < 1 && secondalter.love == true && secondalter.courage <= function.rdmgen(25, time(NULL)))
    {
        gg *= -1;
        hh *= -1;
    }
}

void functions::phasespaceoutput(person &phaseone, person &phasetwo, double phasefeelone[], double phasefeeltwo[], bool firstrun, double &onefeel, double &twofeel, bool &perccommevolve, bool specinteract)
{//to output phase space coordinates and to determine when to do so
    string outputfilename = "generated data/"; //resets and ensures placement within "generated data" folder
    if (specinteract == true) //unique output file for specific interactions
        outputfilename += phaseone.name + phasetwo.name + " specificinteraction.txt";
    else if (firstrun == true) //get at least one output; else if avoids multiple outputs for same run
        outputfilename += phaseone.name + phasetwo.name + " firstrun.txt";
    else if (onefeel > 3.6 && phaseone.love == true && twofeel > 3.6 && phasetwo.love == true)
        outputfilename += phaseone.name + phasetwo.name + " mutuallove.txt";
    else if (onefeel < -3.75 && phaseone.hate == true && twofeel < -3.75 && phasetwo.hate == true)
        outputfilename += phaseone.name + phasetwo.name + " mutualhate.txt";
    else if (onefeel > 3.6 && phaseone.love == true && twofeel < -3.75 && phasetwo.hate == true)
        outputfilename += phaseone.name + phasetwo.name + " lovehate.txt";
    else if (onefeel < -3.75 && phaseone.hate == true && twofeel > 3.6 && phasetwo.love == true)
        outputfilename += phaseone.name + phasetwo.name + " hatelove.txt";
    else if (abs(onefeel) < 1 && abs(twofeel) < 1)
        outputfilename += phaseone.name + phasetwo.name + " mutualapathy.txt";
    if (outputfilename != "generated data/") //output phase space if one condition was met
    {
        ifstream astream(outputfilename.c_str()); //to check if output file already exists
        if (!astream.is_open()) //which happens here; if it does already exist, prevent duplicate generation messages
            cout << "Phase space portrait \"" << outputfilename << "\" generated." << endl; //displays phase spaces generated;
        astream.close();
        ofstream stream(outputfilename.c_str(), ios_base::app); //store multiple outputs in one file
        for (int i = 0; i < 21; i++)
        {
            stream << phasefeelone[i] << '\t' << phasefeeltwo[i] << endl;
        }
        newpersonone.profileview(phaseone, &stream); //output attributes of each person to the phase space file
        newpersonone.profileview(phasetwo, &stream);
        stream << '\n';
        stream << "Perception/Communication Bonus: " << perccommevolve << endl; //output whether perception/communication bonus triggered
        stream << '\n';
        stream.close();
    }
}

void functions::tabulator(double &feelingsone, person &persontheone, person &restorertheone) //tabs up feelings and love/hate count
{//also final determination of love/hate during each run
    restorertheone.feelings += feelingsone; //tab-up feelings into the stored non-varied original person
    if (feelingsone > 3.6 && persontheone.love == true)
        restorertheone.lovecount++;
    if (feelingsone < -3.75 && persontheone.hate == true)
        restorertheone.hatecount++;
}

void functions::results(person &firstperson, person &secondperson, double divisor) //displays summary of results of simulation
{
    function.clearscreen();
    cout << endl << "Final average feelings of " << firstperson.name << " is " << (firstperson.feelings / divisor) << endl;
    cout << "Love Count: " << firstperson.lovecount << endl;
    cout << "Hate Count: " << firstperson.hatecount << endl;
    cout << "Luck Attribute: " << (firstperson.luck * 10 + 10) << endl;
    cout << endl << "Final average feelings of " << secondperson.name << " is " << (secondperson.feelings / divisor) << endl;
    cout << "Love Count: " << secondperson.lovecount << endl;
    cout << "Hate Count: " << secondperson.hatecount << endl;
    cout << "Luck Attribute: " << (secondperson.luck * 10 + 10) << endl << endl;
    cout << endl << "Positive feelings represent liking the other person, whereas negative feelings represent disliking the other person." << endl;
    cout << "1 to -1 should be regarded as apathy." << endl;
    cout << "Over 3.3 or under -3.3 should be regarded as stronger feelings in either direction." << endl;
    cout << "Check the \"generated data\" folder for the output of the final feelings of each pair and for interesting feelings evolution outputs." << endl;
    cout << endl << "Press return twice to continue.";
    cin.ignore().get();
}
