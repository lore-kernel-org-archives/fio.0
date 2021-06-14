Return-Path: <fio-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:16142 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhFNO31 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Jun 2021 10:29:27 -0400
From: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Subject: Windows FIO and Partitions
Date: Mon, 14 Jun 2021 14:27:21 +0000
Message-ID: <MW3PR11MB47616B4B3C8F101CFD859F87A9319@MW3PR11MB4761.namprd11.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I know in Windows I can address physical disks like so:
filename=3D\\.\PhysicalDrive3

Is there a way to address partitions on a physical drive?  I'm looking for =
something like:
filename=3D\\.\PhysicalDrive3\Partition1

Except that syntax doesn't actually work.  Is there one that does?

Thanks!

