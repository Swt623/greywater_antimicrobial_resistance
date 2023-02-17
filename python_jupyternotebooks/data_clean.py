"""
This file is used to clean data file
"""

import pandas as pd

# sort by aggregated abundance and get the top n features from a dataframe
# dataframe has sample name as column, features (taxonomy annotation) as index
# return a new dataframe containing top n features
def sort_top_n(df, n):
    # put dataframe index (taxonomy names) in a list
    organism_list = list(df.index)
    # create an empty dictionary
    organism_sum = {}
    for organism in organism_list:
        organism_sum[organism] = sum(filter(lambda i: isinstance(i, float), list(df.loc[organism])))
        # get top n organism by abundance
        top_n_organism = sorted(organism_sum, key=organism_sum.get, reverse=True)[:n]
    top_n_df = pd.DataFrame()
    # append top n organism data to the new dataframe and save to top_n_df
    top_n_df = top_n_df.append(df.loc[top_n_organism])
    return top_n_df

# rename index names
def clean_index_names(df, sep):
    # read in a dataframe and a separator for the index name cleaning

    # get the list of index names
    index_list = list(df.index)
    for name in index_list:
        name_list = name.split(sep)
        n = len(name_list)
    # get the last nonempty item of the name list 
        for i in range (1,n):
            if name_list[-i] != "":
                df.rename(index = {name: name_list[-i]}, inplace=True)
                break
    return df

# join output with metadata
def add_meta(data_file, meta_file):
    # read in file name variables for datafile and metadata file (tab sperated):
    data_df = pd.read_csv(data_file, delimiter = "\t", index_col=0)
    meta_df = pd.read_csv(meta_file, delimiter = "\t", index_col=0)
    data_df = data_df.set_axis(list(meta_df.columns), axis=1)
    data_df = meta_df.append(data_df)
    data_df.index.name = "Feature"
    return data_df

