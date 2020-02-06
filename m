Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf1-f43.google.com ([209.85.167.43]:42243 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbgBFU7L (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Feb 2020 15:59:11 -0500
Received: by mail-lf1-f43.google.com with SMTP id y19so41682lfl.9
        for <fio@vger.kernel.org>; Thu, 06 Feb 2020 12:59:08 -0800 (PST)
MIME-Version: 1.0
From: Frank Esposito <fpesposito@gmail.com>
Date: Thu, 6 Feb 2020 15:58:55 -0500
Message-ID: <CAFqEa-CTzhZcUAnGn2i4d6ZKwqz5=p6zeKYJ2LEvu1VMJO9JYQ@mail.gmail.com>
Subject: crash
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello --

I am running win 10 / 1909  64bit --- all current update applied --

I download the win binaries  including the zip ones  --

I unzipped  fio-3.16-x64.zip   and ran fio.exe --- Is it looking for a DLL


This is the text from the event log ---


Windows cannot access the file for one of the following reasons:  there is a
problem with the network connection, the disk that the file is stored on, or the
storage drivers installed on this computer; or the disk is missing.  Windows
closed the program fio.exe because of this error.

Program:  fio.exe File:

The error value is listed in the Additional Data section.  User Action 1. Open
the file again.  This situation might be a temporary problem that corrects
itself when the program runs again.

2. If the file still cannot be accessed and

- It is on the network, your network administrator should verify that there is
not a problem with the network and that the server can be contacted.

- It is on a removable disk, for example, a floppy disk or CD-ROM, verify that
the disk is fully inserted into the computer.

3. Check and repair the file system by running CHKDSK.  To run CHKDSK, click
Start, click Run, type CMD, and then click OK.  At the command prompt, type
CHKDSK /F, and then press ENTER.

4. If the problem persists, restore the file from a backup copy.

5. Determine whether other files on the same disk can be opened.  If not, the
disk might be damaged.  If it is a hard disk, contact your administrator or
computer hardware vendor for further assistance.

Additional Data Error value:  00000000 Disk type:  0 -


-- 
Frank Esposito

