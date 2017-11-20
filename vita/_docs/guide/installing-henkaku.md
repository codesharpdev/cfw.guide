---
title: Installing HENkaku
category: Guide
order: 3
---

This part will guide you through installing HENkaku and custom homebrew software. The exploit will require you to relaunch the exploit on every reboot via the HENkaku website, but don't worry, we'll install a version which doesn't require this later.

## Instructions

1. Open the Web Browser on your PS Vita
2. Go to [https://henkaku.xyz/go](https://henkaku.xyz/go){:target="_blank"}

MolecularShell and HENkaku should now be installed on your Vita

## Enabling Unsafe Homebrew

This will allow us to access the Vita's internal memory and install homebrew which requires extended permissions. This can be dangerous and I recommend that beginners turn this off once they're finished with the guide.

1. Open the Settings application
1. Select HENkaku Settings
1. Check **Enable Unsafe Homebrew**

## Enabling downloads

The Vita's browser only lets us download certain types of files, such as audio and video files. Unfortunately, it won't normally let us download Vita homebrew files, but with the Download Enabler plugin, we can download any file we want!

<ol>
	<li>Open the Web Browser on your PS Vita and navigate to this page</li>
	<li>Click the following link to download <a href="http://cfw.guide/vita/files/de3.mp4">Download Enabler v3</a> onto your Vita</li>
	<li>Open MolecularShell and navigate to <code>ux0:video/XX</code></li>
	<li>Rename <code>de3.mp4</code> to <code>de3.suprx</code></li>
	<li>Press Triangle and copy the file</li>
	<li>Navigate to <code>ur0:tai</code> and paste it there</li>
	<li>Open <code>config.txt</code> and add the following text</li>
	<pre>*main
ur0:tai/de3.suprx</pre>
	<li>Exit and save changes</li>
	<li>Delete <code>ux0:tai</code></li>
	<li>Reboot your console</li>
</ol>

## Installing Homebrew

Now we've got that out the way, we can start to download some homebrew applications to put on our Home Menu

1. Open the Web Browser on your PS Vita and navigate to this page
2. Download the latest release of [VitaShell](https://github.com/TheOfficialFloW/VitaShell/releases/latest){:target="_blank"}
3. Download the latest release of [Vita Homebrew Browser](https://github.com/devnoname120/vhbb/releases/latest){:target="_blank"}
4. Open MolecularShell and navigate to `ux0:download`
5. Install both of the homebrew applications you just downloaded
* Make sure you still have unsafe homebrew enabled

You can now use VitaShell as your main file browser, and use Vita Homebrew Browser to download whatever homebrew you want. Keep in mind that Unsafe Homebrew must be enabled to run Vita Homebrew Browser.

<center><a href="../installing-enso" style="text-decoration: none;color: #ccc;font-weight:normal;"><button style="vertical-align:middle"><span>Installing Ensō</span></button></a></center>