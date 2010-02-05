Return-Path: <fio-owner@vger.kernel.org>
Received: from snt0-omc1-s26.snt0.hotmail.com ([65.55.90.37]:31491 "EHLO
	snt0-omc1-s26.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933355Ab0BEXkO convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Fri, 5 Feb 2010 18:40:14 -0500
Message-ID: <SNT103-W60447568C188F46ABEC5CEFF540@phx.gbl>
From: "H. Tolley" <h_tolley@hotmail.com>
Subject: FIO bug
Date: Fri, 5 Feb 2010 16:30:41 -0700
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


The function static void get_file_system_type(struct fio_file *f)=EF=BF=BD=
=EF=BF=BD (in file filesetup.c)
has a call to lstat(..) which if given a symbolic link will give informatio=
n about the link=20
instead of information about the target of the link.=EF=BF=BD In Solaris it=
 is very common that the=20
disk device nodes in /dev/dsk/ are symbolic links to files in /devices/... =
and so the call=20
to lstat(..) will not properly identify a file as a block device instead of=
 a normal file.=EF=BF=BD=20

A call to stat(..) on a filename that represents a block device will not re=
turn the proper=20
size on Solaris.=EF=BF=BD Combined with the above-mentioned mis-identificat=
ion of a link to a=20
block device as a normal file, the function file_size(..) is invoked rather=
 than a call
to bdev_size(..) and fio will not run properly.

Fix: Can the call to lstat(..) in get_file_system_type(..) be replaced by a=
 call to stat(..)?

This happens on Open Solaris v10 x86_64.

Hal Tolley
 		 	   		 =20
_________________________________________________________________
Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
http://clk.atdmt.com/GBL/go/201469229/direct/01/