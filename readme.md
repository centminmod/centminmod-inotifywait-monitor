Create systemd service at `/etc/systemd/system/inotify-monitor.service` for script installed at `/root/tools/inotify-monitor/inotifywait-monitor.sh`

To monitor CSF Firewall's geolocation database directory at `/var/lib/csf/Geo`

```
[Service]
ExecStart=/bin/bash -c '/root/tools/inotify-monitor/inotifywait-monitor.sh /var/lib/csf/Geo'
Restart=always
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=inotify-monitor

[Install]
WantedBy=multi-user.target
```

```
systemctl start inotify-monitor
systemctl enable inotify-monitor
systemctl status inotify-monitor
```
```
journalctl -fu inotify-monitor
```

```
cd /var/lib/csf/Geo
touch test
rm -f test
touch test
rm -f test
```
```
journalctl -fu inotify-monitor
-- Logs begin at Mon 2022-08-01 13:10:21 EDT. --
Aug 03 01:27:18 almalinux-8 systemd[1]: Started inotify-monitor.service.
Aug 03 01:27:35 almalinux-8 inotify-monitor[4131306]: [Wed Aug  3 01:27:35 EDT 2022]: The file /var/lib/csf/Geo/test was created
Aug 03 01:28:09 almalinux-8 inotify-monitor[4131322]: [Wed Aug  3 01:28:09 EDT 2022]: The file /var/lib/csf/Geo/test was deleted
Aug 03 01:28:16 almalinux-8 inotify-monitor[4131326]: [Wed Aug  3 01:28:16 EDT 2022]: The file /var/lib/csf/Geo/test was created
Aug 03 01:28:54 almalinux-8 inotify-monitor[4131348]: [Wed Aug  3 01:28:54 EDT 2022]: The file /var/lib/csf/Geo/test was deleted
```