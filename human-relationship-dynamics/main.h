//////////////////////////////////////////////////////////////////////////////
//Human Relationship Dynamics Version 25/4/2010 FINAL
//
//Please do not distribute source code without permission.
//////////////////////////////////////////////////////////////////////////////

#ifndef MAIN_H
#define MAIN_H

long static state = 0; //must be stored outside of calls to rdmgen and alters its state between calls
int choice; //just easier this way

//////////////////////////////////////////////////////////////////////////////
//
//People Declarations
//
//////////////////////////////////////////////////////////////////////////////

class person
{
public:
    double humor, friendliness, kindness, activeinterests, charisma, quirky, socialgroups, altruism, education, luck; //initial condition attributes (all from -1 to 1; interface 0-20)
    double sensitivity, selfmotivation, trustnaive, arrogance; //dynamic coefficients (see below)
    int communication, perception, selfawareness, emotionstoic, passiveaggressive; //timestep variables and +- multipliers (see below)
    double appearance, wealth, adventurous, relationshipmaturity, power, intell; //threshold attributes (more important to kick over to love/hate than i.c.; from -2 to 2, interface 0-20)
    int avoidsconflict, courage, honesty, age; //special variables
    bool love, hate; //the non-numeric check for love and hate
    int lovecount, hatecount, avoidcount, couragecount, despondcount; //counter
    double feelings; //stored feelings
    char gender; //'M' or 'F'
    string name; //name of person
    void creator(), customcreate(ofstream &saveperson), mate(person &mateone, person &matetwo, ofstream &baby), loadcustom(person &persontoload, ifstream &loadperson);
    void profileview(person &viewperson, ostream *out), builtinedit(person personedit);
};

person romeo, juliet, robot, pirate, introvert, extrovert, narcissist, flamboyant, polygamist, comedian, conservative, robber, hippie; //list of built in people
person newpersonone; //for custom people; vector is copy-constructor so only one object needed
vector<person> vectorofpeople; //accessible list of all the people

void person::creator()
{
    romeo.name = "Default Male";
    romeo.gender = 'M';
    romeo.humor = 0.0;
    romeo.friendliness = 0.0;
    romeo.kindness = 0.0;
    romeo.activeinterests = 0.0;
    romeo.charisma = 0.0;
    romeo.quirky = 0.0;
    romeo.socialgroups = 0.0;
    romeo.altruism = 0.0;
    romeo.education = 0.0;
    romeo.luck = 0;
    romeo.sensitivity = 1; //amplification strength of reaction to change in other's feelings (0.67-1.5 nonlinear; interface 0-20)
    romeo.selfmotivation = 1; //amplification strength of reaction to change in one's own feelings (0.67-1.5 nonlinear; interface 0-20)
    romeo.perception = 2; //number of timesteps needed for reaction to change in others' feelings (1-3)
    romeo.communication = 2; //number of timesteps needed to convey need for reaction in others' feelings (1-3)
    romeo.selfawareness = 2; //number of timesteps needed for reaction to change in one's own feelings (1-3)
    romeo.trustnaive = 1; //amplification strength of reaction to change in other's feelings and dampening strength of reaction to change in one's own feelings (0.5-2 linear; interface 0-20)
    romeo.arrogance = 1; //amplification strength of reaction to change in one's own feelings and dampening strength of reaction to change in other's feelings (0.5-2 linear; interface 0-20)
    romeo.emotionstoic = 1; //+-1 multiplier on one's own feelings
    romeo.passiveaggressive = 1; //+-1 multiplier on others' feelings (feels opposite of others compared to way others feel about him/her)
    romeo.appearance = 0.0;
    romeo.wealth = 0.0;
    romeo.adventurous = 0.0;
    romeo.relationshipmaturity = 0.0;
    romeo.power = 0.0;
    romeo.intell = 0.0;
    romeo.avoidsconflict = 12; //someone's probability to reduce others' negativity yet not strive for a positive relationship in that instance (if quantity(0-25) > rng(25)) ---> true)
    romeo.courage = 12; //probability to go from stoic to emotion based on strong positive feelings from other person
    romeo.honesty = 12; //causes a variation in feelings that other person must randomly "guess" from
    romeo.age = 3; //affects priorities in subjective evaluation of characteristics
    romeo.love = false;
    romeo.hate = false;
    vectorofpeople.push_back(romeo);

    juliet.name = "Default Female";
    juliet.gender = 'F';
    juliet.humor = 0.0;
    juliet.friendliness = 0.0;
    juliet.kindness = 0.0;
    juliet.activeinterests = 0.0;
    juliet.charisma = 0.0;
    juliet.quirky = 0.0;
    juliet.socialgroups = 0.0;
    juliet.altruism = 0.0;
    juliet.education = 0.0;
    juliet.luck = 0;
    juliet.sensitivity = 1;
    juliet.selfmotivation = 1;
    juliet.perception = 2;
    juliet.communication = 2;
    juliet.selfawareness = 2;
    juliet.trustnaive = 1;
    juliet.arrogance = 1;
    juliet.emotionstoic = 1;
    juliet.passiveaggressive = 1;
    juliet.appearance = 0.0;
    juliet.wealth = 0.0;
    juliet.adventurous = 0.0;
    juliet.relationshipmaturity = 0.0;
    juliet.power = 0.0;
    juliet.intell = 0.0;
    juliet.avoidsconflict = 12;
    juliet.courage = 12;
    juliet.honesty = 12;
    juliet.age = 3;
    juliet.love = false;
    juliet.hate = false;
    vectorofpeople.push_back(juliet);

    robot.name = "Robot";
    robot.gender = 'M';
    robot.humor = -1.0;
    robot.friendliness = 0.4;
    robot.kindness = 0.0;
    robot.activeinterests = -0.3;
    robot.charisma = -0.7;
    robot.quirky = 0.2;
    robot.socialgroups = 0.0;
    robot.altruism = 1.0;
    robot.education = 0.0;
    robot.luck = 0;
    robot.sensitivity = 1.2;
    robot.selfmotivation = 0.0;
    robot.perception = 3;
    robot.communication = 1;
    robot.selfawareness = 1;
    robot.trustnaive = 2;
    robot.arrogance = 0.5;
    robot.emotionstoic = -1;
    robot.passiveaggressive = 1;
    robot.appearance = -1.6;
    robot.wealth = 0.0;
    robot.adventurous = -1.0;
    robot.relationshipmaturity = 1.2;
    robot.power = 0.0;
    robot.intell = 1.0;
    robot.avoidsconflict = 25;
    robot.courage = 0;
    robot.honesty = 25;
    robot.age = 3;
    robot.love = false;
    robot.hate = false;
    vectorofpeople.push_back(robot);

    pirate.name = "Pirate";
    pirate.gender = 'M';
    pirate.humor = 0.5;
    pirate.friendliness = -0.6;
    pirate.kindness = -1.0;
    pirate.activeinterests = 0.2;
    pirate.charisma = -0.4;
    pirate.quirky = 0.3;
    pirate.socialgroups = -0.2;
    pirate.altruism = -0.4;
    pirate.education = -0.6;
    pirate.luck = 0;
    pirate.sensitivity = (1/1.3);
    pirate.selfmotivation = 1.45;
    pirate.perception = 3;
    pirate.communication = 1;
    pirate.selfawareness = 1;
    pirate.trustnaive = 0.5;
    pirate.arrogance = 2;
    pirate.emotionstoic = 1;
    pirate.passiveaggressive = 1;
    pirate.appearance = -0.6;
    pirate.wealth = 2.0;
    pirate.adventurous = 2.0;
    pirate.relationshipmaturity = -1.0;
    pirate.power = 1.6;
    pirate.intell = 0.4;
    pirate.avoidsconflict = 0;
    pirate.courage = 25;
    pirate.honesty = 0;
    pirate.age = 3;
    pirate.love = false;
    pirate.hate = false;
    vectorofpeople.push_back(pirate);

    introvert.name = "Introvert";
    introvert.gender = 'M';
    introvert.humor = -0.3;
    introvert.friendliness = -0.7;
    introvert.kindness = 0.1;
    introvert.activeinterests = 0.9;
    introvert.charisma = -0.6;
    introvert.quirky = 0.1;
    introvert.socialgroups = -0.5;
    introvert.altruism = -0.4;
    introvert.education = 0.6;
    introvert.luck = 0;
    introvert.sensitivity = 1.35;
    introvert.selfmotivation = (1/1.4);
    introvert.perception = 3;
    introvert.communication = 3;
    introvert.selfawareness = 1;
    introvert.trustnaive = (1/1.4);
    introvert.arrogance = 1.3;
    introvert.emotionstoic = -1;
    introvert.passiveaggressive = 1;
    introvert.appearance = -0.8;
    introvert.wealth = 0.2;
    introvert.adventurous = -1.2;
    introvert.relationshipmaturity = 1.4;
    introvert.power = -0.4;
    introvert.intell = 0.8;
    introvert.avoidsconflict = 17;
    introvert.courage = 6;
    introvert.honesty = 12;
    introvert.age = 3;
    introvert.love = false;
    introvert.hate = false;
    vectorofpeople.push_back(introvert);

    extrovert.name = "Extrovert";
    extrovert.gender = 'M';
    extrovert.humor = 0.4;
    extrovert.friendliness = 1.0;
    extrovert.kindness = -0.2;
    extrovert.activeinterests = 0.2;
    extrovert.charisma = 0.6;
    extrovert.quirky = -0.4;
    extrovert.socialgroups = 0.7;
    extrovert.altruism = 0.3;
    extrovert.education = -0.2;
    extrovert.luck = 0;
    extrovert.sensitivity = 1.1;
    extrovert.selfmotivation = (1/1.35);
    extrovert.perception = 1;
    extrovert.communication = 1;
    extrovert.selfawareness = 3;
    extrovert.trustnaive = 1.5;
    extrovert.arrogance = (1/1.7);
    extrovert.emotionstoic = 1;
    extrovert.passiveaggressive = 1;
    extrovert.appearance = 0.4;
    extrovert.wealth = 0.6;
    extrovert.adventurous = 1.0;
    extrovert.relationshipmaturity = -0.8;
    extrovert.power = 0.4;
    extrovert.intell = -0.2;
    extrovert.avoidsconflict = 21;
    extrovert.courage = 22;
    extrovert.honesty = 7;
    extrovert.age = 3;
    extrovert.love = false;
    extrovert.hate = false;
    vectorofpeople.push_back(extrovert);

    narcissist.name = "Narcissist";
    narcissist.gender = 'M';
    narcissist.humor = 0.3;
    narcissist.friendliness = 1.0;
    narcissist.kindness = -0.8;
    narcissist.activeinterests = 0.4;
    narcissist.charisma = 1.0;
    narcissist.quirky = -0.2;
    narcissist.socialgroups = 0.8;
    narcissist.altruism = -1.0;
    narcissist.education = 0.1;
    narcissist.luck = 0;
    narcissist.sensitivity = (2.0/3.0);
    narcissist.selfmotivation = 1.5;
    narcissist.perception = 3;
    narcissist.communication = 1;
    narcissist.selfawareness = 2;
    narcissist.trustnaive = 0.5;
    narcissist.arrogance = 2;
    narcissist.emotionstoic = 1;
    narcissist.passiveaggressive = 1;
    narcissist.appearance = 1.6;
    narcissist.wealth = 0.4;
    narcissist.adventurous = 0.2;
    narcissist.relationshipmaturity = -2.0;
    narcissist.power = 0.6;
    narcissist.intell = 0.2;
    narcissist.avoidsconflict = 8;
    narcissist.courage = 10;
    narcissist.honesty = 10;
    narcissist.age = 3;
    narcissist.love = false;
    narcissist.hate = false;
    vectorofpeople.push_back(narcissist);

    flamboyant.name = "Flamboyant";
    flamboyant.gender = 'M';
    flamboyant.humor = 0.3;
    flamboyant.friendliness = 0.4;
    flamboyant.kindness = 0.0;
    flamboyant.activeinterests = -0.4;
    flamboyant.charisma = 0.5;
    flamboyant.quirky = 0.4;
    flamboyant.socialgroups = 0.6;
    flamboyant.altruism = 0.0;
    flamboyant.education = 0.3;
    flamboyant.luck = 0;
    flamboyant.sensitivity = 1.4;
    flamboyant.selfmotivation = 1.3;
    flamboyant.perception = 1;
    flamboyant.communication = 2;
    flamboyant.selfawareness = 2;
    flamboyant.trustnaive = (2.0/3.0);
    flamboyant.arrogance = 1.1;
    flamboyant.emotionstoic = 1;
    flamboyant.passiveaggressive = 1;
    flamboyant.appearance = 1.2;
    flamboyant.wealth = 0.4;
    flamboyant.adventurous = 0.2;
    flamboyant.relationshipmaturity = 0.8;
    flamboyant.power = 0.0;
    flamboyant.intell = 0.4;
    flamboyant.avoidsconflict = 5;
    flamboyant.courage = 23;
    flamboyant.honesty = 21;
    flamboyant.age = 3;
    flamboyant.love = false;
    flamboyant.hate = false;
    vectorofpeople.push_back(flamboyant);

    polygamist.name = "Polygamist";
    polygamist.gender = 'M';
    polygamist.humor = -0.3;
    polygamist.friendliness = 0.7;
    polygamist.kindness = 0.4;
    polygamist.activeinterests = -0.4;
    polygamist.charisma = 0.2;
    polygamist.quirky = -0.7;
    polygamist.socialgroups = 0.2;
    polygamist.altruism = -0.5;
    polygamist.education = 0.2;
    polygamist.luck = 0;
    polygamist.sensitivity = (10.0/11.0);
    polygamist.selfmotivation = (10.0/11.0);
    polygamist.perception = 2;
    polygamist.communication = 2;
    polygamist.selfawareness = 2;
    polygamist.trustnaive = 1.3;
    polygamist.arrogance = 1.2;
    polygamist.emotionstoic = -1;
    polygamist.passiveaggressive = 1;
    polygamist.appearance = 0.6;
    polygamist.wealth = -0.2;
    polygamist.adventurous = -1.0;
    polygamist.relationshipmaturity = 1.6;
    polygamist.power = 0.4;
    polygamist.intell = 0.6;
    polygamist.avoidsconflict = 23;
    polygamist.courage = 15;
    polygamist.honesty = 8;
    polygamist.age = 3;
    polygamist.love = false;
    polygamist.hate = false;
    vectorofpeople.push_back(polygamist);

    comedian.name = "Edgy Comedian";
    comedian.gender = 'F';
    comedian.humor = 1.0;
    comedian.friendliness = 0.6;
    comedian.kindness = -0.8;
    comedian.activeinterests = 0.0;
    comedian.charisma = 0.7;
    comedian.quirky = 0.8;
    comedian.socialgroups = 0.4;
    comedian.altruism = -0.3;
    comedian.education = -0.5;
    comedian.luck = 0;
    comedian.sensitivity = (10.0/13.5);
    comedian.selfmotivation = 1.4;
    comedian.perception = 1;
    comedian.communication = 1;
    comedian.selfawareness = 3;
    comedian.trustnaive = (10.0/18.0);
    comedian.arrogance = 1.2;
    comedian.emotionstoic = 1;
    comedian.passiveaggressive = 1;
    comedian.appearance = 0.6;
    comedian.wealth = -0.8;
    comedian.adventurous = 1.0;
    comedian.relationshipmaturity = 1.0;
    comedian.power = -1.0;
    comedian.intell = 0.6;
    comedian.avoidsconflict = 4;
    comedian.courage = 15;
    comedian.honesty = 10;
    comedian.age = 2;
    comedian.love = false;
    comedian.hate = false;
    vectorofpeople.push_back(comedian);

    conservative.name = "Right-Wing Conservative";
    conservative.gender = 'M';
    conservative.humor = -0.7;
    conservative.friendliness = -0.6;
    conservative.kindness = 0.0;
    conservative.activeinterests = 0.1;
    conservative.charisma = -0.3;
    conservative.quirky = -0.4;
    conservative.socialgroups = -0.3;
    conservative.altruism = -0.3;
    conservative.education = 0.4;
    conservative.luck = 0;
    conservative.sensitivity = (10.0/12.0);
    conservative.selfmotivation = 1.45;
    conservative.perception = 3;
    conservative.communication = 2;
    conservative.selfawareness = 3;
    conservative.trustnaive = 0.625;
    conservative.arrogance = 1.3;
    conservative.emotionstoic = -1;
    conservative.passiveaggressive = -1;
    conservative.appearance = 0.8;
    conservative.wealth = 0.8;
    conservative.adventurous = -0.8;
    conservative.relationshipmaturity = 0.2;
    conservative.power = 0.8;
    conservative.intell = 0.6;
    conservative.avoidsconflict = 2;
    conservative.courage = 18;
    conservative.honesty = 8;
    conservative.age = 2;
    conservative.love = false;
    conservative.hate = false;
    vectorofpeople.push_back(conservative);

    robber.name = "Robber Baron";
    robber.gender = 'M';
    robber.humor = 0.1;
    robber.friendliness = -0.4;
    robber.kindness = -0.5;
    robber.activeinterests = 0.7;
    robber.charisma = 0.5;
    robber.quirky = 0.0;
    robber.socialgroups = 0.2;
    robber.altruism = -0.9;
    robber.education = 0.5;
    robber.luck = 0;
    robber.sensitivity = 1.1;
    robber.selfmotivation = (10.0/11.0);
    robber.perception = 1;
    robber.communication = 2;
    robber.selfawareness = 2;
    robber.trustnaive = 0.625;
    robber.arrogance = 1.6;
    robber.emotionstoic = 1;
    robber.passiveaggressive = 1;
    robber.appearance = 0.4;
    robber.wealth = 2.0;
    robber.adventurous = 0.6;
    robber.relationshipmaturity = 0.0;
    robber.power = 2.0;
    robber.intell = 1.0;
    robber.avoidsconflict = 12;
    robber.courage = 19;
    robber.honesty = 3;
    robber.age = 5;
    robber.love = false;
    robber.hate = false;
    vectorofpeople.push_back(robber);

    hippie.name = "Hippie";
    hippie.gender = 'F';
    hippie.humor = 0.0;
    hippie.friendliness = 0.3;
    hippie.kindness = 0.4;
    hippie.activeinterests = 0.4;
    hippie.charisma = 0.3;
    hippie.quirky = -0.4;
    hippie.socialgroups = -0.5;
    hippie.altruism = 0.8;
    hippie.education = -0.3;
    hippie.luck = 0;
    hippie.sensitivity = 1.25;
    hippie.selfmotivation = 1.25;
    hippie.perception = 2;
    hippie.communication = 1;
    hippie.selfawareness = 1;
    hippie.trustnaive = 1.6;
    hippie.arrogance = (5.0/6.0);
    hippie.emotionstoic = 1;
    hippie.passiveaggressive = 1;
    hippie.appearance = 0.8;
    hippie.wealth = -1.2;
    hippie.adventurous = 1.2;
    hippie.relationshipmaturity = 0.0;
    hippie.power = -1.0;
    hippie.intell = 0.8;
    hippie.avoidsconflict = 22;
    hippie.courage = 12;
    hippie.honesty = 22;
    hippie.age = 2;
    hippie.love = false;
    hippie.hate = false;
    vectorofpeople.push_back(hippie);
}

//////////////////////////////////////////////////////////////////////////////
//
//Function Declarations
//
//////////////////////////////////////////////////////////////////////////////

class functions
{
public:
    void listcustompeople(), genderbias(person &theperson), menu(), simulation(), interaction(person &personfirst, person &personsecond), renamer(int &slotdeleted), clearscreen();
    void phasespaceoutput(person &phaseone, person &phasetwo, double phasefeelone[], double phasefeeltwo[], bool firstrun, double &onefeel, double &twofeel, bool &perccommevolve, bool specinteract);
    void tabulator(double &feelingsone, person &persontheone, person &restorertheone), specificcarelevel(person &specone, person &spectwo, double &specinitfeel), introscreen();
    void coefficientevolution(double &aa, double &bb, double &gg, double&hh, int &ll, int &mm, double &feelone, double &feeltwo, person &firstalter, person &secondalter, bool &atimeevolve), listpeople();
    void currentdebug(person &debugperson), rngcarelevel(person &carelevelone, person &careleveltwo, double &weightedinitone), preloader(), speclovehate(person &speclhone, person &speclhtwo, double &speclhinit);
    void peoplevariations(person &aperson), lovehatecheck(person &onecheck, person &twocheck, double initone), specificinteraction(person &personfirst, person &personsecond);
    void results(person &firstperson, person &secondperson, double divisor), personattributesoutputter(person &personoutput, ofstream &astream);
    void aiextra(double aifeelone[], double aifeeltwo[], person &aione, person &aitwo, double &aa, double &bb, double &cc, double &dd, double &ee, double &ff, double &gg, double&hh, int &kk, int &ll, int &mm, int &nn);
    int rdmgen(int maxnum, long tempstate), crossovermateint(int &crossone, int &crosstwo);
    double visualscaler(double attributevalue, int scaler), programscaler(double attributevalue, double scaler), timematefunc(double combinedtimevar), feelingsscaler(double feel);
    double variableboundary(double value, int bound), crossovermate(double &crossone, double &crosstwo);
    string customslot(int slotnum);
};

functions function; //to use functions

#endif // MAIN_H
