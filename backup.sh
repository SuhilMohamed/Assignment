#!/bin/bash

# Database Credentials (Replace with your details)
DB_USER="your_username"
DB_PASSWORD="your_password"
DB_NAME="your_database_name"

# Backup Directory (Ensure it exists and has write permissions)
BACKUP_DIR="/path/to/backups"

# Get current date in YYYY-MM-DD format
DATE=$(date +%Y-%m-%d)

# Create filename with timestamp
BACKUP_FILE="$BACKUP_DIR/mysql_${DB_NAME}_${DATE}.sql.gz"

# Log with timestamp
echo "$(date +%Y-%m-%d_%H:%M:%S) - Starting database backup..." >> "$BACKUP_DIR/backup.log"

# Dump database and compress with gzip
mysqldump --no-tablespaces --user="$DB_USER" --password="$DB_PASSWORD" "$DB_NAME" | gzip > "$BACKUP_FILE"

# Check if backup successful
if [ $? -eq 0 ]; then
  echo "$(date +%Y-%m-%d_%H:%M:%S) - Database backup completed successfully to: $BACKUP_FILE" >> "$BACKUP_DIR/backup.log"
else
  echo "$(date +%Y-%m-%d_%H:%M:%S) - Database backup failed!" >> "$BACKUP_DIR/backup.log"
fi

exit 0
