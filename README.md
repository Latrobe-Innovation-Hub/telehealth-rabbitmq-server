# rabbitmq-server
rabbitmq-server configuration files

## How To Backup and Restore RabbitMQ Configurations

Please note this backup doesn’t include Messages since they are stored in a separate message store. It will only backup RabbitMQ users, vhosts, queues, exchanges, and bindings. The backup file is a JSON representation of RabbitMQ metadata. We will do a backup using rabbitmqadmincommand line tool.

The management plugin ships with a command line tool rabbitmqadmin. You need to enable the management plugin:
```bash
rabbitmq-plugins enable rabbitmq_management
```

This plugin is used to perform some of the same actions as the Web-based UI, and which may be more convenient for automation tasks.

Download rabbitmqadmin
Once you enable the management plugin, download rabbitmqadmin  Python command line tool that interacts with the HTTP API. It can be downloaded from any RabbitMQ node that has the management plugin enabled at
```bash
http://{node-hostname}:15672/cli/
```

Once downloaded, make the file executable and move it to /usr/local/bin directory:
```bash
chmod +x rabbitmqadmin
sudo mv rabbitmqadmin /usr/local/bin
```

To backup RabbitMQ configurations, use the command:
```bash
rabbitmqadmin export <backup-file-name>
```

Example:
```bash
$ rabbitmqadmin export rabbitmq-backup-config.json
Exported definitions for localhost to "rabbitmq-backup-config.json"
```
The export will be written to filerabbitmq-backup-config.json

## How to Restore RabbitMQ Configurations backup

If you ever want to restore your RabbitMQ configurations from a backup, use the command:
```bash
rabbitmqadmin import <JSON backup file >
```

Example
```bash
$ rabbitmqadmin import rabbitmq-backup.json 
Imported definitions for localhost from "rabbitmq-backup.json"
```
