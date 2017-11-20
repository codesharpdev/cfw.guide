---
title: Adrenaline
category: More
order: 1
---

Adrenaline is an extremely useful piece of software which lets you run PS1 and PSP games and homebrew from your memory card.

## Instructions
<ol>
	<li>Download the latest release of <a href="https://github.com/TheOfficialFloW/Adrenaline/releases/latest" target="_blank">Adrenaline</a></li>
	<li>Download the latest release of <a href="http://cfw.guide/vita/files/PSPhbb_dev.vpk">PSP Homebrew Browser</a></li>
	<li>Install both files using a file manager such as VitaShell or MolecularShell</li>
	<li>Open the Adrenaline application from the home menu</li>
	<li>Press X to download the PSP 6.61 firmware</li>
	<ul>
		<li>Adrenaline will automatically close</li>
	</ul>
	<li>Open Adrenaline again and press <b>X</b> to install the firmware</li>
	<li>Press X to boot the PSP XMB</li>
	<li>Once you've set up the Vita, hold the <b>PS</b> button and select <b>Settings > Exit PspEmu Application</b></li>
	<li>Open up VitaShell or MolecularShell and navigate to <code>ur0:tai</code></li>
	<li>Open up <code>config.txt</code> and make the following changes</li>
	<pre>*KERNEL
ux0:app/PSPEMUCFW/sce_module/adrenaline_kernel.skprx</pre>
	<li>Reboot</li>
</ol>

You now have a working PSP XMB on your Vita! You can play games by putting the ISOs into the `ux0:pspemu/PSP/ISO` directory, and install homebrew by putting it into the `ux0:pspemu/PSP/GAME` directory.