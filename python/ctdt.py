import pandas as pd


def forward_model(df):
    """weighted linear model for forwards"""
    # calculate new normalized column
    df['Normalized'] = (0.9 * df['Dribble'] + 1.0 * df['Shot'] +
                        0.8 * df['Pass'] + 0.5 * df['Tackle'] +
                        0.0 * df['Block'] + 0.3 * df['Intercept'] +
                        df['Speed'] + df['Power'] + df['Technique']) / df['Total']
    return df


# import data sheet
DF = pd.read_excel('https://docs.google.com/spreadsheets/u/1/d/1E9rwAbRXrU2wjjMe6521z2HxMQnPKdVY8RfVzxzCzyE/export?format=xlsx&id=1E9rwAbRXrU2wjjMe6521z2HxMQnPKdVY8RfVzxzCzyE')

# calculate for each position
print(forward_model(df=DF).sort_values(by=['Normalized'], ascending=False))


# TODO: models for other positions, clean up output dataframe, abstract model functions into one function with different model parameters
