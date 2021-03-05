Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:43644 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhCETCv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 5 Mar 2021 14:02:51 -0500
From: Brandon Paupore <Brandon.Paupore@wdc.com>
Subject: Unified RW Reporting - Separate and Mixed
Date: Fri, 5 Mar 2021 19:02:47 +0000
Message-ID: <BYAPR04MB415017A64F5736D557C5B0B0FD969@BYAPR04MB4150.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Sean Brownlow <sean.brownlow@wdc.com>, Jeffrey Lien <Jeff.Lien@wdc.com>

Howdy folks,

I've put up a pull request (https://github.com/axboe/fio/pull/1198) to add =
functionality to the unified_rw_reporting parameter to output separate and =
mixed stats when set to 2. This will allow for both sets of statistics to b=
e gathered from running a single workload with its particular timings/rando=
m generations/etc.

Let me know if you have any feedback or if these changes should be supplied=
 as a patch in an email to this list.

Thanks for your time,
Brandon Paupore

