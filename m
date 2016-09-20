Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20949 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754016AbcITSiK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Sep 2016 14:38:10 -0400
From: Greg Frees <greg.frees@hgst.com>
Subject: Can FIO replay a "blktrace/blkparse" command list in Windows?
Date: Tue, 20 Sep 2016 18:38:07 +0000
Message-ID: <BN6PR04MB0788FC374E1CD50A85DE51ECE3F70@BN6PR04MB0788.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I need to be able to replay the cmds and the cmd timing that has been captu=
red and parsed with blktrace and blkparse using FIO on a Windows 7 computer=
.

Can FIO for Windows replay the output file from blkparse?  (I have not had =
luck trying this)


If the answer is "yes", can you please provide a short example of a blkpars=
e output file that I can replay using read_iolog in an FIO script running o=
n Windows?  Thanks.
