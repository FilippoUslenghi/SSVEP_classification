function data = load_data(dataFile)
% Loads the data from the h5 file of the dataset and converts it into
% double values

    data = h5read(dataFile, "/20:15:12:22:81:60/raw/channel_4");
    data = cast(data, "double")';
end