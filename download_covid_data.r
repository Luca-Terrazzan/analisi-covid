library(useful)

# Download latest data from github if needed
if (!file.exists('data/global-latest-data.csv')) {
  raw_csv_from_github = read.csv('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv')
  write.csv(raw_csv_from_github, 'data/global-latest-data.csv')
}
covid_data = read.csv('data/global-latest-data.csv')

# Enrich data with new information
covid_data = shift.column(data=covid_data, columns="tamponi", newNames='nuovi_tamponi', up=FALSE)
covid_data['nuovi_tamponi'] = covid_data['tamponi'] - covid_data['nuovi_tamponi']
covid_data['positivi/tamponi'] = covid_data['nuovi_positivi'] / covid_data['nuovi_tamponi']

# Save new dataset
write.csv(covid_data, 'data/global-latest-data-with-proportions.csv')

# Parse date column
dates = as.Date(covid_data['data'][,1])

# Plot
plot(data.frame(dates, covid_data['positivi/tamponi'][,1]), '', 'positives / tests', type='l', col='red')
plot(data.frame(dates, covid_data['totale_positivi'][,1]), '', 'total positives', type='l', col='purple')
plot(data.frame(dates, covid_data['nuovi_positivi'][,1]), '', 'daily positives', type='l', col='black')
plot(data.frame(dates, covid_data['tamponi']), '', 'tests', type='l', col='black')
