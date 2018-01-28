import pandas as pd


def linear_model(df, weights):
    """weighted linear model"""
    # setup output dataframe
    output_df = pd.DataFrame(data={})
    output_df['Name'] = df['Name']
    output_df['Title'] = df['Title']
    output_df['Class'] = df['Class']

    # calculate phys weight
    # 6 (average among six weights) * 2 (only half contributes) * 3 (three individual stats)
    weight_phys = (weights['dribble'] + weights['shot'] +
                   weights['pass'] + weights['tackle'] +
                   weights['block'] + weights['intercept']) / (6 * 2 * 3)

    # calculate new weighted column
    output_df['Weighted'] = (weights['dribble'] * df['Dribble'] +
                             weights['shot'] * df['Shot'] +
                             weights['pass'] * df['Pass'] +
                             weights['tackle'] * df['Tackle'] +
                             weights['block'] * df['Block'] +
                             weights['intercept'] * df['Intercept'] +
                             weight_phys * df['Physical'])

    # calculate new normalized column
    output_df['Normalized'] = output_df['Weighted'] / df['Total']

    # return the modified dataframe
    return output_df


# import data sheet
DF = pd.read_excel('https://docs.google.com/spreadsheets/u/1/d/1E9rwAbRXrU2wjjMe6521z2HxMQnPKdVY8RfVzxzCzyE/export?format=xlsx&id=1E9rwAbRXrU2wjjMe6521z2HxMQnPKdVY8RfVzxzCzyE')

# setup parameter dict
WEIGHTS = {
    'fw': {
        'dribble': 0.9,
        'shot': 1.0,
        'pass': 0.8,
        'tackle': 0.5,
        'block': 0.0,
        'intercept': 0.3
    },
    'am': {},
    'dm': {},
    'df': {},
    'gk': {}
}

# calculate for each position
print(linear_model(df=DF, weights=WEIGHTS['fw']).sort_values(by=['Normalized'], ascending=False))

# TODO: models and code (tabs) for other positions, why did combining weight_phys into one weight / 3 and * total phys change the numbers?; phys stats, skills, stamina
