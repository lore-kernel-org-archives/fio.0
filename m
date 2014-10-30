Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1on0141.outbound.protection.outlook.com ([157.56.112.141]:16416
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751362AbaJ3OGy convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 30 Oct 2014 10:06:54 -0400
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: anonymous mmap issue on solaris
Date: Thu, 30 Oct 2014 14:06:48 +0000
Message-ID: <5416a70b91da426280173bb27a43f0e7@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

An issue on solaris=EF=BF=BD:

Anonymous mmap must have a fd set to -1 in order to work (on linux, it is i=
gnored), in alloc_mem_mmap, the fd is set to 1

[.]
static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
{
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD int flags =3D =
0;

=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD td->mmapfd =3D=
 1;

=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD if (td->o.mem_=
type =3D=3D MEM_MMAPHUGE) {
[.]

Changing it to -1 makes the code working fine.

Bye
Seb

