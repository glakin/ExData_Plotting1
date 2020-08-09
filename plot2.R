library(dplyr)

# Read the data
df <- read.table("household_power_consumption.txt", sep=";",
                 col.names=c("date","time","global_active_power","global_reactive_power",
                             "voltage","global_intensity","sub_metering_1",
                             "sub_metering_2","sub_metering_3"),
                 stringsAsFactors = FALSE
)

# Select specific date range
df <- df[df$date=="1/2/2007"|df$date=="2/2/2007",]

# Replace ? with NA
df <- df %>% 
    mutate_all(~na_if(., "?"))

# Add datetime col and format
df$datetime <- paste(df$date, " ", df$time)
df$date <- as.Date(df$date, format = "%d/%m/%Y")
df$time <- strptime(df$time, "%H:%M:%S")
df$datetime <- strptime(df$datetime, "%d/%m/%Y %H:%M:%S")

# Convert numerical cols to numeric
df <- transform(df, global_active_power = as.numeric(global_active_power),
                global_reactive_power = as.numeric(global_reactive_power),
                voltage = as.numeric(voltage),
                global_intensity = as.numeric (global_intensity),
                sub_metering_1 = as.numeric(sub_metering_1),
                sub_metering_2 = as.numeric(sub_metering_2),
                sub_metering_3 = as.numeric(sub_metering_3))

# Plot the line chart
plot(df$datetime, 
     df$global_active_power, 
     type="n",
     xlab = NA,
     ylab = "Global Active Power (kilowatts)")
lines(df$datetime, df$global_active_power)

# Save as png
dev.copy(png, file = "plot2.png")
dev.off()

