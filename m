Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db3lp0077.outbound.protection.outlook.com ([213.199.154.77]:57874
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933574AbaCSQCk convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 19 Mar 2014 12:02:40 -0400
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: unlink=1 issue on Windows
Date: Wed, 19 Mar 2014 16:02:31 +0000
Message-ID: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm having an issue on windows : unlink=3D1 is not working (temp file are s=
till there) and it's working fine on unix

Looking at the code in close_and_free_files function :

[...]
if (td->o.unlink && f->filetype =3D=3D FIO_TYPE_FILE) {
			dprint(FD_FILE, "free unlink %s\n", f->file_name);
			unlink(f->file_name);
		}
[...]

Unlink() fails because the file is still open : On Solaris, truss shows the=
 following :

[...]
write(3, "\0\0\0\0\0 ;80\0\0\0\0\0".., 32768)   =3D 32768
unlink("/data/fio/random_rw.0.0")               =3D 0
close(3)                                        =3D 0
[...]

So unlink is called first.

I would put this unlinking phase AFTER the remove_file_hash call.

Seb

S=EF=BF=BDbastien BOUCHEX BELLOMI=EF=BF=BD
Infovista=EF=BF=BD Server Technical Lead, Service Assurance R&D


