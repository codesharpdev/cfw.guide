---
title: SD2Vita
category: More
order: 2
---

SD2Vita is a microSD to gamecard adapter for the PS Vita. This means that you can finally use a microSD card as storage for your Vita! It requires a bit of settings up though.

## Instructions
<ol>
<li>Download the <a href="https://github.com/xyzz/gamecard-microsd/releases/download/v1.0/gamesd.skprx">SD2Vita drivers</a></li>
<li>Download the <a href="http://cfw.guide/vita/files/zzBlank.img">zzBlank.img</a> image</li>
<li>If you haven't already, move your <code>ux0:tai</code> folder to <code>ur0:tai</code> and delete the <code>ux0:tai</code></li>
<li>Copy the SD2Vita drivers to <code>ur0:tai</code></li>
<li>Add the following to <code>ur0:tai/config.txt</code></li>
<pre>*KERNEL
ur0:tai/gamesd.skprx</pre>
<li>Backup your Vita Memory Card to your computer via VitaShell using USB or FTP</li>
<ul><li>If you're using USB, make sure you have <a href="https://support.microsoft.com/en-gb/help/14201/windows-show-hidden-files" target="_blank">hidden files enabled</a> and <a href="https://kb.blackbaud.co.uk/articles/Article/41890" target="_blank">hidden operating system files enabled</a></li></ul>
<li>Put your microSD card into your computer</li>
</ol>

## Windows

1. Download the latest release of [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/){:target="_blank"}
2. Open Win32 Disk Imager and select `zzBlank.img` from your computer
3. Select your microSD and click **Write**
4. Take out your microSD card and put it back in again
5. Format your card from Windows
* File System: exFat
* Allocation Unit Size: Default Allocation Size
* Do not put a volume label
6. Copy the backup you made earlier to the SD Card
7. Put the SD Card into the SD2Vita adapter and reboot your Vita

## Linux

1. Find the whole-device node (usually `/dev/sdx`)
* If you're unsure, use the `mount` command
2. Unmount all partitions, but don't eject the microSD
* `umount /dev/sdx`
3. Use the `dd` command to write `zzBlank.img` to the card
* `dd if=/path/zzBlank.img of=/dev/sdx`
4. Take out the micro SD card and put it in again
5. Create a new MBR (msdos) partition table, an exFAT partition, and format that partition
* `mkfs.exfat /dev/sdx`
6. Copy the backup you made earlier to the SD Card
7. Put the SD Card into the SD2Vita adapter and reboot your Vita