Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713EBC4332F
	for <fio@archiver.kernel.org>; Tue, 15 Nov 2022 09:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237821AbiKOJNE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Nov 2022 04:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbiKOJND (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Nov 2022 04:13:03 -0500
X-Greylist: delayed 2002 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 01:13:00 PST
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC66925D5
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 01:13:00 -0800 (PST)
Received: from pps.filterd (m0209323.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF6DxO4000400
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 08:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=S1; bh=QH0IOPb1l0qbcqVaKiUI6GCtpTTqTQ49gOrbnMdYHAg=;
 b=jWQkoVPRS/TbOXsmFwdMrDJOjBr9EpdM9Y3SkDQqjHCrLw00K97uf9PLunh9ZPvTlqgy
 VIBXv7fXdK4a/ARw1ba2qZEQyefT5RTbFhXYPw/BtkADG9ah9ithz6PsPOWDDlaH2r+y
 C+aFysOCeRWJu1wn06zpIq/aSgO9Idt8FuMvJAFC4hlWc2/WmDcAb36tNDyP8/UenfCZ
 r6e4AuXYrfjUbDN40+9RBhgdIHRVCX7LVShcXnWElpLX1RdH72tVceSj6dVZ63NsO9Mo
 cegzhP5GrFDhs5Ovx1mfCqAKjrStiB8PG2dHDlyQmBaPZL/C1/iinybZgzja3C+HwhfK og== 
Received: from apc01-sg2-obe.outbound.protection.outlook.com (mail-sgaapc01lp2107.outbound.protection.outlook.com [104.47.26.107])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3kv3jh086g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 08:39:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGfFipEEsjVM8bfDuLf10rfTpTSEQb0CuAdOow8Z/2L5zkS9Uvff3+Ydx3+HDuVV13n5FBhHiRa2/p5Jw8uZApS+eNZU91lRndajdOT4R7+vfR1vV5/14DdOCuP3f2LbA6lT1Tglz6tT8GsPytaoljNs6Vcg8l5h3Cg/0PgejRiIgrJLoIlzpKrNFPU/gwoCmMeTeeTw5VihJOd+trZSg5u8k3lrJrcjXSEPlb9xAYmXenAtzoPpIxjuT6WQsDkCgwE62TT+7U17X4cIyediD1MKGyMPmC4otohDgVeoIlQd12+Dc4E0zxIr07ZjmZ1jetEytuDGunFw7k1VBEsCTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QH0IOPb1l0qbcqVaKiUI6GCtpTTqTQ49gOrbnMdYHAg=;
 b=If4MOtRc3HEGc00LbATBgfrnj4/IAjZDBfb/ipGkm6KTutIxPZOybSAgZcaplJzYrT9SAa55mt/WXyn/XwJPRftA1hCW4X2zw6+NxPxeuf+daiCrNKGeQgg3M1lBu6RDpcPmDOGHbrnr05yQ919VYeezDx1zLlzeCDbE6HO7dhohwlw4TapL+DdVM84oD9eg9NwtkyIdvmahEIyDyd4cFKhMnvh+JQyhvhzfynWS0Oh96FuRvCIgwKhc3doJ+M04BLdGEIe1iD1XuTbCFaJ8165GW2Ly7VjpnT2L6wsY2H9mviUe5SlAdfyeteENMd8tN0SQs6SUX83R15+7amcbPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by SG2PR04MB3948.apcprd04.prod.outlook.com (2603:1096:0:c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.6; Tue, 15 Nov 2022 08:39:29 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e%7]) with mapi id 15.20.5834.007; Tue, 15 Nov 2022
 08:39:29 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     fio <fio@vger.kernel.org>
CC:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>,
        "Kento.A.Kobayashi@sony.com" <Kento.A.Kobayashi@sony.com>,
        "Friendy.Su@sony.com" <Friendy.Su@sony.com>
Subject: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Thread-Topic: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Thread-Index: Adj4yimqLnbaVLwfS9mikvNy15l48g==
Date:   Tue, 15 Nov 2022 08:39:28 +0000
Message-ID: <HK0PR04MB23884FFF415F7EFCB424CABEFD049@HK0PR04MB2388.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HK0PR04MB2388:EE_|SG2PR04MB3948:EE_
x-ms-office365-filtering-correlation-id: 7476b4b3-48ec-4e61-f9ae-08dac6e4e902
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6yA+OR1PvS+ajHc/49EOiPuppqBjc5Gk0Q/MIbLQU+jwqHWn2fW19fJSZ8sB9a6N2PFkp2IQzVmh2QA4qsM9brmMNbhlRMQ838MDLwYUX0Yro5dYPowyNQLAA6axMB20LjdMwtgyrPKp2Q7E8ywazNT+I6MZyu0I3NK0yq2mns6FDjGPB0xOT+u6pnQMZhzs3DrSFqIU7Px3HpKBlaVgCCrVnsLEIV7cL3MPOnV/Vp9UUnDF3pP6tD1OJK7Y3NNuULm/WvcmYm0XoRxRpIN1VD/jJxECkLJcvYrgDSW624wiAQq1EveVj0WwvOMO8vkXIWpoVy9hVz3pKk1aHjAWLKkFUK6IcLwuUcWuwXIojXNQu8LHArMFS91ohA+yGrxkCXIloBdU+VE3eaohKUtvmDI9Sn1XaNXNDD8DoCFfjN+QS70BXF2Nx0QA3pf3oaomBwxHOi8lZ0STDPCk7u2TvHU9HOG9G7T+uoIzNXkk57F9kME9lzCbEwsyVyDpBSzRcyh53rGLtOK8SwpfBrE9FYeNW7gs/FbrOQjCO+XwzusuWo9ArIDkVhHvQOaF6mYlVUzhEfMB0BN/ONUlf6Q/wnQA6K3hwECkUV1gVSKyhBwzBNvUoUWa2BKTKpWlM8LLWKEuef97+bOepGCsRPQYd2dd5WKVcCJy6fQAg3OVI7d6gNwAHPxTsK1yBmdtleeK15AmP7vEizPWvE/XYgmPq4a9ZDafN4iBzX3V4bbUW9nuDkaWZoG5UD4w8XANeP9EI1gDy2FiUXFx2v3OQoznWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199015)(66446008)(66556008)(66476007)(66946007)(64756008)(76116006)(122000001)(38100700002)(8936002)(2906002)(82960400001)(38070700005)(52536014)(8676002)(30864003)(4326008)(83380400001)(5660300002)(41300700001)(71200400001)(478600001)(9686003)(33656002)(6506007)(7696005)(26005)(107886003)(6916009)(316002)(186003)(54906003)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xRUBeUoDCW+c0ZsGawz1n+zuGIOKyvQl2Hou/90I+sALvAH6YGJ6qkp5a2Wz?=
 =?us-ascii?Q?/XR0X4rnJvpwiQ3HdkCX/CdBctalL9/Y/N1fVBYP7MOjKd5+BNGXcFmDRGsn?=
 =?us-ascii?Q?3CSRgFbkgL3Gy8fYJSMm2r22DfABA0KtfxEzGIe5Wq9s/KRg5lSGqveFDcEH?=
 =?us-ascii?Q?OAvOIHp9E6AVpHYbAMHSPR4+gbZd1ijDb9mgWKOFz0yoaKrQvXciweoktYYO?=
 =?us-ascii?Q?DG4AnWhhQTYizIcSzlM0HwR3yw3SgzVS4kwP/Ayu6o6edXwiRvVjhrBETaC9?=
 =?us-ascii?Q?+YFHRb0I0040rM8k1havuUUKwEcx2rVAdQGZChJqfgZOpVgvL2spnSgYC4Lt?=
 =?us-ascii?Q?PHNgoFWJ4wa8eTki25ZdZ3Mr44WJItCDBo86Rxg1cMSX/TChTFtFJ83kjF/1?=
 =?us-ascii?Q?Y/tSEbrv/jFPQTyzrZPJVQdmABWDs+5zO4gBQ7TWogfemRqjp2QKt4ocXtKX?=
 =?us-ascii?Q?v8+oUwdibceIhWPRZreSLf+JGhWIEkEZNv3x+TtnvIr+KBzO1RZp0t3XXa3h?=
 =?us-ascii?Q?r6pZ8tbs3R08lOp/aTV00m8BzdCB1ssBl1nd7vchKyXdWFBEItvOI2gN2sYq?=
 =?us-ascii?Q?loieUUxUiVPxO35rKMXoyLWmJD6tlV/7F7vWoOM1viqT+h323qNq5p72ZmVG?=
 =?us-ascii?Q?PGHo13hDL8/kyArC9Oivk25k+X20EYWx6yCNOoDo4AEGe9uw730gxIadXD8a?=
 =?us-ascii?Q?0F5VSk9HHQW3w/asGls67jxwExw4caKLsoTXI18HTkARZsorolYdq5ORD2Js?=
 =?us-ascii?Q?ZcMBck1GnmxER4L6f1+6FjpqGGB32ihNHuJLc5QRuIVDcX4RCFb95PJo18nJ?=
 =?us-ascii?Q?WeSFXWhBfxYhHJIrUW5VQ2ybVT68uvGJ0GU5Jd8EmQ8PodtwfzknoB95cvPY?=
 =?us-ascii?Q?Fy3TfleEpGueZFWrTRX4D8XUC7l/zbvYtcF0Q05cK3fJSjvgW2vr7lcp34pe?=
 =?us-ascii?Q?BdIlqe/hmG5CIxMvfCfYoox8LIrRYJoVeC3d7gAzSqLYViDnVCO8UvnpHhmT?=
 =?us-ascii?Q?qGfDGQeqXBj9WAK/3JBPTCoxbF/jkzVyEqmVqhTf2gFP+BJZWR+SRcvTpQRc?=
 =?us-ascii?Q?JfTY3WOUx+7rV71nEsFnHeMcYLuc+shff8KovM95pQL7yVhEYbSYsQ9nl4Vb?=
 =?us-ascii?Q?rZLrzktEXEcRvt+4oCr5L40iEtiWVgt7W0Ac6FLCDo52U8mE1R1488Di4iYt?=
 =?us-ascii?Q?GBp0TtMT/ZVfXQ6/hb0gXJgbr24/ZRIENiAdw1vVDn2OFlJs3VvBstws34v8?=
 =?us-ascii?Q?Fu6dUN0xCscoY4BioUyVcSGuGoYHQKz/QatMnHYZvvl7x7ZEB3HneS96EgAN?=
 =?us-ascii?Q?p8ZUklKxUvkbWOKjcy7Krgfu0zDpVrFsj0pcpTd8iLe2UV33huJyh0jioZZ1?=
 =?us-ascii?Q?Gw8Ei6HyOa9J4YvdojgqdVxF7rRWugPcSrHasJdAgAZgiwXvk+naB1eJf7Yj?=
 =?us-ascii?Q?1gGqgrGfL92/GP0EitLNN5njmsDm2/6v34MyKtZm+8DONyYbY2xUW5OSmqMR?=
 =?us-ascii?Q?WFE7g2vzjASJEwd1+ZBCW1xsOOlcfK4cJYVr3f/d7DGWWICU0alAqtuJtuUg?=
 =?us-ascii?Q?lK1hOWz3SacLe7ErXQKywn/VHbpS7BSsp3MhBet7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: r3YPlazMKH43lgVyDTp94ORgfx6Xu7nBY2fKboHBq7JvC2jadAQU6dq1y7fpOa5tktNA/zqvEBIM1ZKh6OMer6NfPoHGU8x5pUwrB3hUHxOFR+cLx9ZyIx0UWj/SUhG9bCBdVgZu/IYE9CxV5NQi0zQSFtZ0pqdGk5Is7bh7S1avqOu+48907ILYKawQapT6pRw5BQJH1bw//ru8b4j7aDzaOGZQTjr6g+kYBd8JRCHaZ3xz6pXA93vSw/yvyitJYOC6sTUJU2htYWgj+bp5jgS4sUFSXunozpQA3H0qMphM+2j8DRlyCzzWO5dd0Tpwwmje0xOhO1x7YMBq8kP55qa4VovC2Fg1MEaqnSVtzzxZ6gzK/vLWhdXyFFTa5QeZlBtX8WSzwdmwqCJ1AsLEcSUf5Yr+DOmWIEYSDYpMydVwhGC2zoOjsgFxUgHvTTIvg/5rw8Z02xkQm9SUF2d6jUZxz4OUshttoshS5OnGWOgY+rWTsZXc/BpfyIHbMb3iy01hixuKywKo9FhD06bvIctI07mlOol7snAMcscmdZFAkGw3imsbgMwtrJjlP3jEh51baGBci7ZRFbRS4Mud/67v7HseeOCegjS/FR/ONDiADAVUs/O15+EzUwKU95REzqHOucZDGs64nIBmHIwXylFNO0pFwgtE8K5X+dzhAAL3xlg8T7KG+FQohFw1seIL+zTU9M91GlQxm5y49GyWoZJFar30UdEiwx0xAGQgzivPqIwjs7LPqeJbp9sJLoPXWU/+2FbyYdSF0SjhRwE93v2z00fKgJj9t83uwFItyok=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7476b4b3-48ec-4e61-f9ae-08dac6e4e902
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 08:39:28.9850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z1ZuFsv/CWC9ffyEvjAA+VoJRgQGmxwtr6yYSHnGp+V9jlifxmvk8bwjDCfVgJTJF7rZAmZI8c0QzbGKr6hIkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR04MB3948
X-Proofpoint-GUID: kNaLn_R0P5yeO9aOzP_aaqaBfckOvLii
X-Proofpoint-ORIG-GUID: kNaLn_R0P5yeO9aOzP_aaqaBfckOvLii
X-Sony-Outbound-GUID: kNaLn_R0P5yeO9aOzP_aaqaBfckOvLii
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_04,2022-11-11_01,2022-06-22_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Show correct file operation strings in log.

For file operation measurement, 'rw' field is set to 'read' in job file.
The corresponding 'rw' in log is also 'read'. This makes user confused
since file operation and IO read are totally different things.
In this commit, add 3 new file operations to 'rw' field.

For implementation, TD_DDIR_FILECREATE/TD_DDIR_FILESTAT/TD_DDIR_FILEDELETE
are added. Meanwhile, DDIR_FILE_OP is added to identify the file
operation and IO operation. DDIR_FILE_OP is same value as
DDIR_READ, then clat_stat[DDIR_FILE_READ] can be 'borrowed' for file
operation statistics. Just set DDIR_FILE_OP_MASK when get io_ddir_name().
This avoid big code change if add a new index to enum fio_ddir.

With this commit, user can explicitly specify the exact file operation
in job file 'rw' field. 'rw' string and 'ddir' string in log is also
correct.

Example:

$ fio   filestat-ioengine.fio
t0: (g=3D0): rw=3Dfilestat, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096=
B-4096B, ioengine=3Dfilestat, iodepth=3D1
t1: (g=3D0): rw=3Dfilestat, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096=
B-4096B, ioengine=3Dfilestat, iodepth=3D1
fio-3.33
Starting 2 threads

t0: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D4744: Thu Nov 10 18:24:00 2022
  file_operation: IOPS=3D20.0k, BW=3D78.1MiB/s (81.9MB/s)(80.0KiB/1msec)
    clat (nsec): min=3D12645, max=3D29394, avg=3D13751.35, stdev=3D3690.55
    clat percentiles (nsec):
     |  1.00th=3D[12608],  5.00th=3D[12608], 10.00th=3D[12736], 20.00th=3D[=
12736],
     | 30.00th=3D[12736], 40.00th=3D[12736], 50.00th=3D[12864], 60.00th=3D[=
12992],
     | 70.00th=3D[12992], 80.00th=3D[13120], 90.00th=3D[13120], 95.00th=3D[=
13760],
     | 99.00th=3D[29312], 99.50th=3D[29312], 99.90th=3D[29312], 99.95th=3D[=
29312],
     | 99.99th=3D[29312]

Signed-off-by: friendy-su <friendy.su@sony.com>
---
 HOWTO.rst                        |  6 ++++++
 backend.c                        |  3 +++
 engines/fileoperations.c         |  7 +++----
 examples/filecreate-ioengine.fio |  1 +
 examples/filedelete-ioengine.fio |  1 +
 examples/filestat-ioengine.fio   |  1 +
 fio.1                            | 10 ++++++++++
 fio.h                            |  1 +
 io_ddir.h                        | 26 ++++++++++++++++++++++++--
 io_u.c                           |  7 ++++---
 iolog.c                          |  2 +-
 options.c                        | 12 ++++++++++++
 stat.c                           | 21 +++++++++++++++++----
 stat.h                           |  1 +
 14 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index e796f961..c176b7d3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1137,6 +1137,12 @@ I/O type
 		**randtrimwrite**
 				Like trimwrite, but uses random offsets rather
 				than sequential writes.
+		**filecreate**
+				Create a batch of files.
+		**filestat**
+				Stat a batch of files.
+		**filedelete**
+				Delete a batch of files.
=20
 	Fio defaults to read if the option is not specified.  For the mixed I/O
 	types, the default is to split them 50/50.  For certain types of I/O the
diff --git a/backend.c b/backend.c
index ba954a6b..7024003a 100644
--- a/backend.c
+++ b/backend.c
@@ -1924,6 +1924,9 @@ static void *thread_main(void *data)
 			update_runtime(td, elapsed_us, DDIR_WRITE);
 		if (td_trim(td) && td->io_bytes[DDIR_TRIM])
 			update_runtime(td, elapsed_us, DDIR_TRIM);
+		if (td_fileoperate(td) && td->io_bytes[DDIR_FILE_OP])
+			update_runtime(td, elapsed_us, DDIR_FILE_OP);
+
 		fio_gettime(&td->start, NULL);
 		fio_sem_up(stat_sem);
=20
diff --git a/engines/fileoperations.c b/engines/fileoperations.c
index 1db60da1..3b44d429 100644
--- a/engines/fileoperations.c
+++ b/engines/fileoperations.c
@@ -245,12 +245,11 @@ static int init(struct thread_data *td)
=20
 	data =3D calloc(1, sizeof(*data));
=20
-	if (td_read(td))
-		data->stat_ddir =3D DDIR_READ;
-	else if (td_write(td))
-		data->stat_ddir =3D DDIR_WRITE;
+	if (td_fileoperate(td))
+		data->stat_ddir =3D DDIR_FILE_OP;
=20
 	td->io_ops_data =3D data;
+	td->file_op_flag =3D DDIR_FILE_OP_MASK;
 	return 0;
 }
=20
diff --git a/examples/filecreate-ioengine.fio b/examples/filecreate-ioengin=
e.fio
index ec7caad5..86226b19 100644
--- a/examples/filecreate-ioengine.fio
+++ b/examples/filecreate-ioengine.fio
@@ -10,6 +10,7 @@
 # IO will not really be done and the write latency numbers will only refle=
ct the
 # open times.
 [global]
+rw=3Dfilecreate
 create_on_open=3D1
 nrfiles=3D31250
 ioengine=3Dfilecreate
diff --git a/examples/filedelete-ioengine.fio b/examples/filedelete-ioengin=
e.fio
index 3c0028f9..6fa2b6a7 100644
--- a/examples/filedelete-ioengine.fio
+++ b/examples/filedelete-ioengine.fio
@@ -5,6 +5,7 @@
 # 'unlink' is better set to 0, since the file is deleted in measurement.
 # the options disabled completion latency output such as 'disable_clat' an=
d 'gtod_reduce' must not set.
 [global]
+rw=3Dfiledelete
 ioengine=3Dfiledelete
 filesize=3D4k
 nrfiles=3D200
diff --git a/examples/filestat-ioengine.fio b/examples/filestat-ioengine.fi=
o
index 932fced8..d225795b 100644
--- a/examples/filestat-ioengine.fio
+++ b/examples/filestat-ioengine.fio
@@ -4,6 +4,7 @@
 # 'filesize' must be set, then files will be created at setup stage.
=20
 [global]
+rw=3Dfilestat
 ioengine=3Dfilestat
 numjobs=3D1
 filesize=3D4k
diff --git a/fio.1 b/fio.1
index 9e33c9e1..dc22e83d 100644
--- a/fio.1
+++ b/fio.1
@@ -909,6 +909,16 @@ other Fio options limiting the total bytes or number o=
f I/O's.
 Like
 .B trimwrite ,
 but uses random offsets rather than sequential writes.
+.TP
+.B filecreate
+Create a batch of files.
+.TP
+.B filestat
+Stat a batch of files.
+.TP
+.B filedelete
+Delete a batch of files.
+.TP
 .RE
 .P
 Fio defaults to read if the option is not specified. For the mixed I/O
diff --git a/fio.h b/fio.h
index 8da77640..6e6ed780 100644
--- a/fio.h
+++ b/fio.h
@@ -191,6 +191,7 @@ struct thread_data {
 	unsigned int thread_number;
 	unsigned int subjob_number;
 	unsigned int groupid;
+	uint32_t file_op_flag;
 	struct thread_stat ts __attribute__ ((aligned(8)));
=20
 	int client_type;
diff --git a/io_ddir.h b/io_ddir.h
index 217eb628..7de5926b 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -14,8 +14,17 @@ enum fio_ddir {
=20
 	DDIR_RWDIR_CNT =3D 3,
 	DDIR_RWDIR_SYNC_CNT =3D 4,
+
+	/*
+	 * file operation ddir 'borrows' DDIR_READ, then ts->clat_stat[0] is also=
 borrowed
+	 * only when print by io_ddir_name(), DDIR_FILE_OP_MASK is set to print "=
file_operation"
+	 * string
+	 */
+	DDIR_FILE_OP =3D 0,
 };
=20
+#define DDIR_FILE_OP_MASK	0x80
+
 #define for_each_rw_ddir(ddir)	for (enum fio_ddir ddir =3D 0; ddir < DDIR_=
RWDIR_CNT; ddir++)
=20
 static inline const char *io_ddir_name(enum fio_ddir ddir)
@@ -24,7 +33,10 @@ static inline const char *io_ddir_name(enum fio_ddir ddi=
r)
 					"datasync", "sync_file_range",
 					"wait", };
=20
-	if (ddir >=3D 0 && ddir < DDIR_LAST)
+
+	if (ddir & DDIR_FILE_OP_MASK)
+		return "file_operation";
+	else if (ddir >=3D 0 && ddir < DDIR_LAST)
 		return name[ddir];
=20
 	return "invalid";
@@ -42,6 +54,12 @@ enum td_ddir {
 	TD_DDIR_RANDTRIM	=3D TD_DDIR_TRIM | TD_DDIR_RAND,
 	TD_DDIR_TRIMWRITE	=3D TD_DDIR_TRIM | TD_DDIR_WRITE,
 	TD_DDIR_RANDTRIMWRITE	=3D TD_DDIR_RANDTRIM | TD_DDIR_WRITE,
+
+	TD_DDIR_FILEOP		=3D 1 << 4,
+	TD_DDIR_FILEOP_MASK	=3D TD_DDIR_FILEOP | (TD_DDIR_FILEOP - 1),
+	TD_DDIR_FILECREATE	=3D TD_DDIR_FILEOP | 0,
+	TD_DDIR_FILESTAT	=3D TD_DDIR_FILEOP | 1,
+	TD_DDIR_FILEDELETE	=3D TD_DDIR_FILEOP | 2,
 };
=20
 #define td_read(td)		((td)->o.td_ddir & TD_DDIR_READ)
@@ -54,6 +72,10 @@ enum td_ddir {
 					=3D=3D TD_DDIR_TRIMWRITE)
 #define td_randtrimwrite(td)	(((td)->o.td_ddir & TD_DDIR_RANDTRIMWRITE) \
 					=3D=3D TD_DDIR_RANDTRIMWRITE)
+#define td_filecreate(td)	(((td)->o.td_ddir & TD_DDIR_FILEOP_MASK) =3D=3D =
TD_DDIR_FILECREATE)
+#define td_filestat(td)		(((td)->o.td_ddir & TD_DDIR_FILEOP_MASK) =3D=3D T=
D_DDIR_FILESTAT)
+#define td_filedelete(td)	(((td)->o.td_ddir & TD_DDIR_FILEOP_MASK) =3D=3D =
TD_DDIR_FILEDELETE)
+#define td_fileoperate(td)	((td)->o.td_ddir & TD_DDIR_FILEOP)
=20
 static inline int ddir_sync(enum fio_ddir ddir)
 {
@@ -71,7 +93,7 @@ static inline const char *ddir_str(enum td_ddir ddir)
 	static const char *__str[] =3D { NULL, "read", "write", "rw", "rand",
 				"randread", "randwrite", "randrw",
 				"trim", NULL, "trimwrite", NULL, "randtrim",
-				NULL, "randtrimwrite" };
+				NULL, "randtrimwrite", NULL, "filecreate", "filestat", "filedelete" };
=20
 	return __str[ddir];
 }
diff --git a/io_u.c b/io_u.c
index 8035f4b7..aaea3fdd 100644
--- a/io_u.c
+++ b/io_u.c
@@ -674,7 +674,6 @@ static enum fio_ddir rate_ddir(struct thread_data *td, =
enum fio_ddir ddir)
 	enum fio_ddir odir =3D ddir ^ 1;
 	uint64_t usec;
 	uint64_t now;
-
 	assert(ddir_rw(ddir));
 	now =3D utime_since_now(&td->epoch);
=20
@@ -782,6 +781,8 @@ static enum fio_ddir get_rw_ddir(struct thread_data *td=
)
 		ddir =3D DDIR_WRITE;
 	else if (td_trim(td))
 		ddir =3D DDIR_TRIM;
+	else if (td_fileoperate(td))
+		ddir =3D DDIR_FILE_OP;
 	else
 		ddir =3D DDIR_INVAL;
=20
@@ -1426,7 +1427,7 @@ static void lat_fatal(struct thread_data *td, struct =
io_u *io_u, struct io_compl
 		log_err("fio: latency of %llu nsec exceeds specified max (%llu nsec): %s=
 %s %llu %llu\n",
 					tnsec, max_nsec,
 					io_u->file->file_name,
-					io_ddir_name(io_u->ddir),
+					io_ddir_name(io_u->ddir | td->file_op_flag),
 					io_u->offset, io_u->buflen);
 	}
 	td_verror(td, ETIMEDOUT, "max latency exceeded");
@@ -1862,7 +1863,7 @@ static void __io_u_log_error(struct thread_data *td, =
struct io_u *io_u)
 		io_u->file ? " on file " : "",
 		io_u->file ? io_u->file->file_name : "",
 		strerror(io_u->error),
-		io_ddir_name(io_u->ddir),
+		io_ddir_name(io_u->ddir | td->file_op_flag),
 		io_u->offset, io_u->xfer_buflen);
=20
 	if (td->io_ops->errdetails) {
diff --git a/iolog.c b/iolog.c
index aa9c3bb1..7b9d7088 100644
--- a/iolog.c
+++ b/iolog.c
@@ -49,7 +49,7 @@ void log_io_u(const struct thread_data *td, const struct =
io_u *io_u)
 	fio_gettime(&now, NULL);
 	fprintf(td->iolog_f, "%llu %s %s %llu %llu\n",
 		(unsigned long long) utime_since_now(&td->io_log_start_time),
-		io_u->file->file_name, io_ddir_name(io_u->ddir), io_u->offset,
+		io_u->file->file_name, io_ddir_name(io_u->ddir | td->file_op_flag), io_u=
->offset,
 		io_u->buflen);
=20
 }
diff --git a/options.c b/options.c
index 9e4d8cd1..bbe0eada 100644
--- a/options.c
+++ b/options.c
@@ -1951,6 +1951,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] =3D {
 			    .oval =3D TD_DDIR_RANDTRIMWRITE,
 			    .help =3D "Randomly trim and write mix, trims preceding writes"
 			  },
+			  { .ival =3D "filecreate",
+			    .oval =3D TD_DDIR_FILECREATE,
+			    .help =3D "Create file with file size zero"
+			  },
+			  { .ival =3D "filestat",
+			    .oval =3D TD_DDIR_FILESTAT,
+			    .help =3D "Stat files"
+			  },
+			  { .ival =3D "filedelete",
+			    .oval =3D TD_DDIR_FILEDELETE,
+			    .help =3D "Delete files"
+			  },
 		},
 	},
 	{
diff --git a/stat.c b/stat.c
index b963973a..c52c946c 100644
--- a/stat.c
+++ b/stat.c
@@ -517,6 +517,11 @@ static double convert_agg_kbytes_percent(struct group_=
run_stats *rs,
 	return p_of_agg;
 }
=20
+uint32_t get_file_op_flag_from_ts(struct thread_stat *ts)
+{
+		return ts->file_op_flag;
+}
+
 static void show_ddir_status(struct group_run_stats *rs, struct thread_sta=
t *ts,
 			     enum fio_ddir ddir, struct buf_output *out)
 {
@@ -526,16 +531,19 @@ static void show_ddir_status(struct group_run_stats *=
rs, struct thread_stat *ts,
 	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st =3D NULL;
 	int i2p, i;
 	const char *clat_type =3D ts->lat_percentiles ? "lat" : "clat";
+	uint32_t file_op_flag;
+
+	file_op_flag =3D get_file_op_flag_from_ts(ts);
=20
 	if (ddir_sync(ddir)) {
 		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
 			log_buf(out, "  %s:\n", "fsync/fdatasync/sync_file_range");
-			display_lat(io_ddir_name(ddir), min, max, mean, dev, out);
+			display_lat(io_ddir_name(ddir | file_op_flag), min, max, mean, dev, out=
);
 			show_clat_percentiles(ts->io_u_sync_plat,
 						ts->sync_stat.samples,
 						ts->percentile_list,
 						ts->percentile_precision,
-						io_ddir_name(ddir), out);
+						io_ddir_name(ddir | file_op_flag), out);
 		}
 		return;
 	}
@@ -569,7 +577,7 @@ static void show_ddir_status(struct group_run_stats *rs=
, struct thread_stat *ts,
 	}
=20
 	log_buf(out, "  %s: IOPS=3D%s, BW=3D%s (%s)(%s/%llumsec)%s\n",
-			(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir=
),
+			(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir=
 | file_op_flag),
 			iops_p, bw_p, bw_p_alt, io_p,
 			(unsigned long long) ts->runtime[ddir],
 			post_st ? : "");
@@ -1441,6 +1449,9 @@ static void add_ddir_status_json(struct thread_stat *=
ts,
 	double mean, dev, iops;
 	struct json_object *dir_object, *tmp_object;
 	double p_of_agg =3D 100.0;
+	uint32_t file_op_flag;
+
+	file_op_flag =3D get_file_op_flag_from_ts(ts);
=20
 	assert(ddir_rw(ddir) || ddir_sync(ddir));
=20
@@ -1449,7 +1460,7 @@ static void add_ddir_status_json(struct thread_stat *=
ts,
=20
 	dir_object =3D json_create_object();
 	json_object_add_value_object(parent,
-		(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir)=
, dir_object);
+		(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir =
| file_op_flag), dir_object);
=20
 	if (ddir_rw(ddir)) {
 		bw_bytes =3D 0;
@@ -2487,6 +2498,8 @@ void __show_run_stats(void)
 		memcpy(ts->percentile_list, td->o.percentile_list, sizeof(td->o.percenti=
le_list));
 		opt_lists[j] =3D &td->opt_list;
=20
+		ts->file_op_flag =3D td->file_op_flag;
+
 		idx++;
=20
 		if (ts->groupid =3D=3D -1) {
diff --git a/stat.h b/stat.h
index 4c3bf71f..f67965f9 100644
--- a/stat.h
+++ b/stat.h
@@ -175,6 +175,7 @@ struct thread_stat {
 	uint32_t members;
 	uint32_t unified_rw_rep;
 	uint32_t disable_prio_stat;
+	uint32_t file_op_flag;
=20
 	/*
 	 * bandwidth and latency stats
--=20
2.17.1

