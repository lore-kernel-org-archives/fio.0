Return-Path: <fio-owner@vger.kernel.org>
Received: from [213.199.154.11] ([213.199.154.11]:43559 "EHLO
	emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754151AbaCLPir convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 12 Mar 2014 11:38:47 -0400
From: =?iso-8859-1?Q?S=E9bastien_Bouchex_Bellomi=E9?= 
	<sbouchex@infovista.com>
Subject: Bug with "multi directory support" on windows
Date: Wed, 12 Mar 2014 15:38:23 +0000
Message-ID: <e54fd34a63624f1ca306d3a6970272ac@DB4PR03MB572.eurprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

A nice bug on Windows=EF=BF=BD:

My profile is :

[global]
thread

[random_read]
rw=3Drandread
size=3D1024m
directory=3Dc:\temp\fio\read
bs=3D32k

fio start looks like :
C:\Program Files\fio>fio.exe H:\fio\fio.win
fio: c is not a directory
fio: failed parsing directory=3Dc:\temp\fio\read
fio: job random_read dropped
fio: file:options.c:875, func=3Dlstat, error=3DNo such file or directory

Of course ! The : separator of the multi directory support feature does not=
 filter the Windows drive letter

Seb

S=EF=BF=BDbastien BOUCHEX BELLOMI=EF=BF=BD
Infovista=EF=BF=BD Server Technical Lead, Service Assurance R&D


