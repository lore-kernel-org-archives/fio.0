Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:65301 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZLXSql (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 24 Dec 2009 13:46:41 -0500
Received: by iwn1 with SMTP id 1so5910638iwn.33
        for <fio@vger.kernel.org>; Thu, 24 Dec 2009 10:46:39 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 24 Dec 2009 10:46:39 -0800
Message-ID: <e2a756a20912241046s45d9348eob541e1c57cc0c5d7@mail.gmail.com>
Subject: Question regarding --section option
From: Daniel Buggie <danielabuggie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm not totally sure if this is a user-error thing or a bug, but it
appears the --section command is broken.  Using 1.36 and the
surface-scan example job (included below), I get the following output:

# fio --showcmd surface-scan
fio --thread=1 --bs=64k --direct=1 --ioengine=sync --verify=meta
--verify_pattern=0xaa555aa5 --verify_interval=512 --name=write-phase
--rw=write --fill_device=1 --do_verify=0 --filename=datafile.tmp
--name=verify-phase --stonewall --create_serialize=0 --rw=read
--do_verify=1 --filename=datafile.tmp

# fio --showcmd surface-scan --section 'write-phase'
fio --thread=1 --bs=64k --direct=1 --ioengine=sync --verify=meta
--verify_pattern=0xaa555aa5 --verify_interval=512

Basically, it's only getting the global bits of the jobfile.  So am I
doing something wrong to identify the section or is this a bug?  There
does not seem to be a check to see if the specified section exists so
that might be something to add.  I've tried moving the order around,
different quotations, etc. but haven't had any luck.


; writes 512 byte verification blocks until the disk is full,
; then verifies written data
[global]
thread=1
bs=64k
direct=1
ioengine=sync
verify=meta
verify_pattern=0xaa555aa5
verify_interval=512

[write-phase]
filename=datafile.tmp   ; or use a full disk, for example /dev/sda
rw=write
fill_device=1
do_verify=0

[verify-phase]
stonewall
create_serialize=0
filename=datafile.tmp
rw=read
do_verify=1


Regards,
Daniel
