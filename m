Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53064 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab0BFWgV (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 6 Feb 2010 17:36:21 -0500
Date: Sat, 6 Feb 2010 23:36:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: FIO bug
Message-ID: <20100206223619.GQ1025@kernel.dk>
References: <SNT103-W60447568C188F46ABEC5CEFF540@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <SNT103-W60447568C188F46ABEC5CEFF540@phx.gbl>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "H. Tolley" <h_tolley@hotmail.com>
Cc: fio@vger.kernel.org

On Fri, Feb 05 2010, H. Tolley wrote:
>=20
> The function static void get_file_system_type(struct fio_file *f)=EF=BF=
=BD=EF=BF=BD
> (in file filesetup.c) has a call to lstat(..) which if given a
> symbolic link will give information about the link instead of
> information about the target of the link.=EF=BF=BD In Solaris it is very
> common that the disk device nodes in /dev/dsk/ are symbolic links to
> files in /devices/... and so the call to lstat(..) will not properly
> identify a file as a block device instead of a normal file.=EF=BF=BD=20
>=20
> A call to stat(..) on a filename that represents a block device will
> not return the proper size on Solaris.=EF=BF=BD Combined with the
> above-mentioned mis-identification of a link to a block device as a
> normal file, the function file_size(..) is invoked rather than a call
> to bdev_size(..) and fio will not run properly.
>=20
> Fix: Can the call to lstat(..) in get_file_system_type(..) be replaced
> by a call to stat(..)?
>=20
> This happens on Open Solaris v10 x86_64.

That does look like a bug, that stat should return info about the real
device and not a potential link. I have committed a fix for that now.

--=20
Jens Axboe

