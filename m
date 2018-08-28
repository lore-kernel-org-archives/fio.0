Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10760 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725724AbeH1EYw (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Aug 2018 00:24:52 -0400
From: Vincent Fu <Vincent.Fu@wdc.com>
Subject: Re: [PATCH] engines/sg: improve error handling
Date: Tue, 28 Aug 2018 00:35:50 +0000
Message-ID: <BYAPR04MB44214493712FCD40DE5B0F2A950A0@BYAPR04MB4421.namprd04.prod.outlook.com>
References: <1535402411-8396-1-git-send-email-vincentfu@gmail.com>
 <CALjAwxj2gkaHOd7XsvVGsqioc0orBc=tguVMfx_=ONYCbvc4LA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, Vincent Fu <vincentfu@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 08/27/2018 06:41 PM, Sitsofe Wheeler wrote:=0A=
> On Mon, 27 Aug 2018 at 21:41, Vincent Fu <vincentfu@gmail.com> wrote:=0A=
>> From: Vincent Fu <Vincent.Fu@wdc.com>=0A=
>>=0A=
>> The Linux sg driver accepts only 16 SCSI commands in flight=0A=
>> at a time per file descriptor. fio does not exit gracefully=0A=
>> when it attempts to queue up 17 or more trim commands via=0A=
>> the sg ioengine. This patch improves error handling in the=0A=
> Does this mean the engine should refuse iodepths greater than 16 in=0A=
> general or are there multiple descriptors?=0A=
>=0A=
The engine should not refuse iodepths greater than 16 in general. The=0A=
purpose of the recent sg changes was to support high QD trim workloads=0A=
by sending multiple ranges in a single SCSI command. --rw=3Drandtrim=0A=
--iodepth=3D256 --iodepth_batch=3D16 will work whereas --rw=3Drandtrim=0A=
--iodepth=3D257 --iodepth_batch=3D16 will fail.=0A=
=0A=

