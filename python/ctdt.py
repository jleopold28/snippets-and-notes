import pandas as pd


class CTDTOptimizer(object):
    """tool to optimize positions in ctdt

       typically we construct with a weight dictionary providing model params

       then we display rankings for a position"""
    # constructor
    def __init__(self, weights):
        # grab dataframe from maintained spreadsheet
        self.df = pd.read_excel('https://docs.google.com/spreadsheets/u/1/d/'
                                '1E9rwAbRXrU2wjjMe6521z2HxMQnPKdVY8RfVzxzCzyE'
                                '/export?format=xlsx&id='
                                '1E9rwAbRXrU2wjjMe6521z2HxMQnPKdVY8RfVzxzCzyE',
                                sheet_name=None)['FW']
        self.weights = weights
        # create a new dataframe for cleaner output
        self.new_df = self.__create_dataframe()

    # public
    def display_position_ranked(self, position, sort='Normalized'):
        """display the rankings for a position"""
        # calculate the rank for a position and add to new dataframe
        self.__calculate_rank(weights=self.weights[position])
        # output new dataframe
        print(self.new_df.sort_values(by=[sort], ascending=False))

    # private
    def __create_dataframe(self):
        """create a new dataframe to output"""
        new_df = pd.DataFrame(data={})
        new_df['Name'] = self.df['Name']
        new_df['Title'] = self.df['Title']
        new_df['Class'] = self.df['Class']

        # return the modified dataframe
        return new_df

    def __calculate_rank(self, weights):
        """calculate the rank for a position"""
        # determine new weighted ranking column
        self.new_df['Weighted'] = self.__calculate_weighted(weights=weights)

        # calculate new normalized column
        self.new_df['Normalized'] = self.new_df['Weighted'] / self.df['Total']

    def __calculate_weighted(self, weights):
        """calculates the weighted ranking for a position"""
        # determine the phys weight for ranking calculation
        weight_phys = self.__calculate_weight_phys(weights=weights)

        # calculate weighted ranking metric
        return (weights['dribble'] * self.df['Dribble'] +
                weights['shot'] * self.df['Shot'] +
                weights['pass'] * self.df['Pass'] +
                weights['tackle'] * self.df['Tackle'] +
                weights['block'] * self.df['Block'] +
                weights['intercept'] * self.df['Intercept'] +
                weight_phys * self.df['Physical'])

    def __calculate_weight_phys(self, weights):
        """calculates the weight for physical stats"""
        # 6 (average among six weights) * 2 (only half contributes) * 3 (three individual stats)
        return (weights['dribble'] + weights['shot'] +
                weights['pass'] + weights['tackle'] +
                weights['block'] + weights['intercept']) / (6 * 2 * 3)


# TODO: models and code for other positions (hardcoded to 'FW' in construct for now; goalkeeper is different weight keys), why did combining weight_phys into one weight / 3 and * total phys change the numbers?, tox, init dicts for each position and then pass around position var, privatize attrs; skills, stamina, team skills
