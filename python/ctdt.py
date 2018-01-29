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
                                sheet_name=None)
        self.weights = weights
        # create a new dataframe for cleaner output
        self.new_df = self.__create_dataframe(positions=weights.keys())

    # public
    def display_position_ranked(self, position, sort='Normalized'):
        """display the rankings for a position"""
        # calculate the rank for a position and add to new dataframe
        self.__calculate_rank(position=position)
        # output new dataframe
        print(self.new_df[position].sort_values(by=[sort], ascending=False))

    # private
    def __create_dataframe(self, positions):
        """create a new dataframe"""
        # init a dict to hold dataframes
        new_df = {}

        for position in positions:
            # create a dataframe for a position
            new_df[position] = pd.DataFrame(data={})
            # populate the position dataframe with necessary info
            new_df[position]['Name'] = self.df[position]['Name']
            new_df[position]['Title'] = self.df[position]['Title']
            new_df[position]['Class'] = self.df[position]['Class']

        # return the modified dataframe
        return new_df

    def __calculate_rank(self, position):
        """calculate the rank for a position"""
        # determine new weighted ranking column
        self.new_df[position]['Weighted'] = self.__calculate_weighted(position=position)

        # calculate new normalized column
        self.new_df[position]['Normalized'] = self.new_df[position]['Weighted'] / self.df[position]['Total']

    def __calculate_weighted(self, position):
        """calculates the weighted ranking for a position"""
        # pare down dicts to save time on lookups
        weights = self.weights[position]
        df = self.df[position]

        if position == 'GK':
            # determine the phys weight for ranking calculation
            # 2 (average among two weights) * 2 (only half contributes)
            weight_phys = (weights['punch'] + weights['catch']) / 4.0
            # calculate weighted ranking metric
            return (weights['punch'] * df['Punch'] +
                    weights['catch'] * df['Catch'] +
                    weight_phys * df['Physical'])
        else:
            # 6 (average among six weights) * 2 (only half contributes)
            weight_phys = (weights['dribble'] + weights['shot'] +
                           weights['pass'] + weights['tackle'] +
                           weights['block'] + weights['intercept']) / 12.0
            return (weights['dribble'] * df['Dribble'] +
                    weights['shot'] * df['Shot'] +
                    weights['pass'] * df['Pass'] +
                    weights['tackle'] * df['Tackle'] +
                    weights['block'] * df['Block'] +
                    weights['intercept'] * df['Intercept'] +
                    weight_phys * df['Physical'])

# TODO: tox, privatize attrs; skills, stamina, team skills, gk phys is hypothetically half power to both, half technique to catching, half speed to punching
