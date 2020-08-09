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

# Set the global parameters to include a 2x2 grid of plots
par(mfrow = c(2, 2))

# Create the 4 plots:
#1
plot(df$datetime, 
     df$global_active_power, 
     type="n",
     xlab = NA,
     ylab = "Global Active Power")
lines(df$datetime, df$global_active_power)

#2
plot(df$datetime, 
     df$voltage, 
     type="n",
     xlab = "datetime",
     ylab = "Voltage")
lines(df$datetime, df$voltage)

#3
plot(df$datetime, 
     df$sub_metering_1, 
     type="n",
     xlab = NA,
     ylab = "Energy sub metering")
lines(df$datetime, df$sub_metering_1, col="black")
lines(df$datetime, df$sub_metering_2, col="red")
lines(df$datetime, df$sub_metering_3, col="blue")
legend("topright", lty = 1, col = c("black", "blue", "red"), bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#4
plot(df$datetime, 
     df$global_reactive_power, 
     type="n",
     xlab = "datetime",
     ylab = "Global_reactive_power")
lines(df$datetime, df$global_reactive_power)

# Save as png
dev.copy(png, file = "plot4.png")
dev.off()

# Reset default to a single plot
par(mfrow = c(1,1))

