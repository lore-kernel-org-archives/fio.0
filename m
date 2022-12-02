Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EBCC4332F
	for <fio@archiver.kernel.org>; Fri,  2 Dec 2022 03:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiLBDYz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 22:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiLBDYy (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 22:24:54 -0500
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14203D78E4
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 19:24:51 -0800 (PST)
Received: from pps.filterd (m0209322.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B22V2Zd008872
        for <fio@vger.kernel.org>; Fri, 2 Dec 2022 03:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=S1; bh=lox0T+UY6jxOE3gjHsZRnHgGLvBOMDvUd7mo6ky85Ek=;
 b=S26oM/wI5XUMiEBhKWwoRNst3sDZ8EZVbPTkvW7wmhJoVuDrGE6ors5JduPfQRuqQ6EQ
 jmeI2S2v2UARKEEpgLnj0X8fgWc8vT1WnF/FQj4oyrLS05TXuRWqDGNsqcIAq+h/h6f8
 C/cFNoeIluuR7sSK87yTEWZwwmFzn9qo8j7EPAAK4/HstwZAo9+PrR9mLn0Q5wbQRHQa
 lqzsBkk8hANL+kAEc166/o0e20l+UCgPxr2Os5hTdJg9o4FGiSSScv/MNxxXDoCdqopQ
 hbBfpGnWeNxSMTm77FZY/RXyC4X2wUZdY7baFoMI8vkTIWPs7SHLZFJ3/D5UiDnTwcYj rw== 
Received: from apc01-tyz-obe.outbound.protection.outlook.com (mail-tyzapc01lp2042.outbound.protection.outlook.com [104.47.110.42])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3m39k8p8y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <fio@vger.kernel.org>; Fri, 02 Dec 2022 03:24:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0oRwbG5TEHNkCfWzjrBYRHYLcqGvrT2GOprdgUSmdMiXNu7g+xt9IjloxjFaVImmWJtmzGI0fgpVIbcukqkhgcODYojZ2liGLPh+PYXREeqz1t/6hrk+JAjBB2/17PqK8QxnIfLPY8hPGd2LaJZaK6va3ygr5ET0O7vXO++zmPwDWpFew/0KOmEfMRHRRvA+wOQumKi8QCz17iUkNucT9LSkaF5cOjpJS1aU8UtlRs6DlQEfP29J+0JymL9r869rxv5aLs1QhL0JWfnLCg7EQCmyQbRtJtZ/KYZjDBXn+GqrBXrQo7fYa5Wurq2haMZ4NyMrE/s6s5J2o1JZNYZgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lox0T+UY6jxOE3gjHsZRnHgGLvBOMDvUd7mo6ky85Ek=;
 b=AKM2pLDxzuw5PW6RvTHeW4v/+2HZOYXyrsg4veFixwBYA8N8xQY2UCSucdZx0hzj5va+B98Gch67LE/eH2rXnXIIVC6Rzy8unzCMdSZ6ge4JBaKtcObrExzbVeiiCrRIABRJ0hmltGi4/4iwyXW3JKvbhkhb7t+AQPdGsQyxWg2PVMHIJrH00LdSBjizuWDADczkl0SChmOCXniq0IjTIUZKQyYVy/2oAkNR25VJrKBKCr7ooj7bVa2i/8/LiXu2xK27kWcX153nsXYeLS/3ASy+vAnT/tqgp/N9kfrMjglXGv4BW4ZZ2VcV8lNWuE2TPtlr23UtFi/m79uIxPWYrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by SEZPR04MB6753.apcprd04.prod.outlook.com (2603:1096:101:ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 03:24:42 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e%3]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 03:24:41 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     fio <fio@vger.kernel.org>
CC:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
Subject: [PATCH v2] fio: Append "filecreate/filestat/filedelete" to
 'readwrite=' field
Thread-Topic: [PATCH v2] fio: Append "filecreate/filestat/filedelete" to
 'readwrite=' field
Thread-Index: AdkF/Wnm6tCd41GwSXmmpVYgTBii5w==
Date:   Fri, 2 Dec 2022 03:24:41 +0000
Message-ID: <HK0PR04MB238880EA157D090AF252654DFD179@HK0PR04MB2388.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HK0PR04MB2388:EE_|SEZPR04MB6753:EE_
x-ms-office365-filtering-correlation-id: 1ef27721-0436-465b-c022-08dad414c067
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0D4tYSD9BPlJz6alaOBGY7LIkS2e9poB2etrs5lCVRO5glRqFS3aCBnFnozreoTm60L/SoiaBTrIsRswxtW9uSdowNlvFjuCigSI6a/+cXI9L5E/OF7zjXVvKFlSaChNifmrzTXIyAxqXCBS5R3W/yFIoT+ceqKzirkIpaBGdJP7wEBaQfk2fsYfOdWO3iOVjNRMTTM1EAj+MaYCe4b77AFInDwY9bzx7zSOomAVSk7Dl8pABon6yCzgG0Fm5zG1zGvYMmps09wWVsiNIiVo3D3Kz9IkV5acWysolGo6kaLDAOfRu/EJ4qJ3DOHk86D3Fc9w45478pFbIS0v/g8mu2nd87K9SjOQ0gfnZyd6Kkvib45RX3byf0D3RSLyZ96MeBBAQcvgk5e1EEdDvo6+4msl9coxXrdoIvu0MMsO6Cj/4DCRf7Cmlib5jSLy7sfC+FucboG2hteN/3vMCmwdw84FVcTAE3Gplt644Na8vuh5Vl37sEV3TTHz2cT74XRvZBDLiIgXJBnyL5T2cuzDKaaHh7iGyNNwX9CYxTinPqipSqsUjzfwTE3qHhSRDbsJIbZlXpABsNP1UTUUSOU+4b2SdbmPPgWwjtHE2eZe4xtz+VaqI5PinmNrMrvJHShXzwKFlvLR0pU7Fy34B1V6XjxR/8L1uEFwwGLvkXBAXZPvRr4ykzaNk/s9sUGdBz2+uANjq77nCP+kGwTXs4I18Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(107886003)(26005)(9686003)(7696005)(71200400001)(38070700005)(6506007)(54906003)(478600001)(55016003)(6916009)(186003)(86362001)(82960400001)(122000001)(38100700002)(83380400001)(33656002)(5660300002)(64756008)(66446008)(66556008)(66946007)(76116006)(66476007)(30864003)(4326008)(8676002)(41300700001)(52536014)(8936002)(2906002)(316002)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vw62MOdSbPX7oyVqbgWG6Y9pAXV5Nt7C6njxG/vP+Xho+sI1DAHUNMnpVIai?=
 =?us-ascii?Q?8nDdPuY6g7mUJJuPdVPKAE/HJ/RUDnsHQ2HcvwyeGCQQoBjSjqn9ase5sZ7i?=
 =?us-ascii?Q?D+NoKa/fSviHxogfA3YaCb3oWeSiuOp+BoOtFhc2FFB1htMHhkknwbjzG46Z?=
 =?us-ascii?Q?7yOCvULTMCX8Bjls87sRBar229uJ8E/5yq9XIEh++pqiR6R9pxZXg6LY4lLu?=
 =?us-ascii?Q?/yH3A3UjHxQK4s9yB0Fufmzu2r5T3vFIxyJWQnGa+fOLAYNyzrfjm8sTaeah?=
 =?us-ascii?Q?Agor/lIk3qvGV0sW7q4+g7O/IfcLjRJtDzrNelsQrmCkulRCUlHqC3Rxy7Pk?=
 =?us-ascii?Q?Z3SoTfNDMEJgkz+ejIlgf50j1y2Udzg1Rreufcn8aLsKDGA5DoW+b3Ce/DyT?=
 =?us-ascii?Q?qd99ctN9flojhkQumUx6405zU8xOpBXwNb38I9CWxTJUct+m+JYPYCpjovvt?=
 =?us-ascii?Q?DBzPOoojFcZ06CJl3jG6DpSTirmQwMP/ZktrgtKBoNlR9U+q10HGLA39Ey+Z?=
 =?us-ascii?Q?SeOkbdS0PKPs7V7uYjss3klcqdDmxlgvD7RtkjKlcvJgk2EFXMk9BE/CIH8X?=
 =?us-ascii?Q?wmWQQi9RNMKg7DpcsLG4oIZBb6RoTfkfIMawJuxmd+hNj3rn5v0yPH2ksfy7?=
 =?us-ascii?Q?tup/8LtTc9KBlyV3EozE6UQTXRR0LuWIW2MW7vuYctX2rrN2RzgcV5oSI2eP?=
 =?us-ascii?Q?W+94uzURP/E0wKmAooWS7I2YhrQ9dCBSkOLY2N/qDtnOsLsrPEMkfr8FvAxl?=
 =?us-ascii?Q?St666gbozEYgQY5Jw6nUxwAs5YTiFAb5d498v/DZl0H3q1+xCqyaFKpT7I5c?=
 =?us-ascii?Q?940S7HbYyi2T8kQ09HRinYrxT2Rub2F1EIIqo1i0RpVQsBILlMycsXIlRwz4?=
 =?us-ascii?Q?FUN/B/UdvLlAlJyIwlLaHtirB/gXHkGrg653eg5Ee1ZB0/FXhFfZXKx2E3yr?=
 =?us-ascii?Q?ZphuhTQObe2K26MvkBJ7QpaW+gjIEoVQdrkixjK1umpjhGft1ZdKEn/kKBqT?=
 =?us-ascii?Q?sncFUpxD0DspeNaHqvxS9z9kcpmtiECzIeN2mt6vVRfjhNqJVL+VwSxSK8Di?=
 =?us-ascii?Q?HdVsQzgHPL3/rCj1vPvYWrd7L0bp51Qwo/veo5V/NtDuPL1VgGvJwyGM3/Uc?=
 =?us-ascii?Q?PvlcUelUNUAcyFwGM+2Hu5NrMt4RGQuB/Dff2E9edzypyr0Ht81dhGkACyZx?=
 =?us-ascii?Q?/B+RUwdsxayV4WCrbXFQHt9YlvhkVS5UoOVStAzFVCCO9FEMX66gbFQaFv1d?=
 =?us-ascii?Q?zBNOkxx0QKdm933+1iZLDOuZKYb7UmMWGrPjXbWIWQjdZjhnrju2TqGobTJw?=
 =?us-ascii?Q?rqtat3N00guVrT3xwkhkJzc54Ki0zmFXd317uA8drhDTln6Y+S4wcphMdWVe?=
 =?us-ascii?Q?xaW6evwA9T8c8M5whizR0cMNW9Jw1b0iVdUCqxQrtdtc+pfENj5G2P5HcYYw?=
 =?us-ascii?Q?I46SO4yxQFrDib529jIQ/FOV2MaAME6WE5STpjNvBuEXVoDNwE8lZoV8NgDv?=
 =?us-ascii?Q?IcatBAGx4+hHcNclilOKRLGYWDu9fg9eHMjW1IzmQBcelqlMSPEPYEGQUIF2?=
 =?us-ascii?Q?OVIi4cQqGuN2G7VlKCu0Dks9EBUZe4DdaTcroLNf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZvVQekxXwPi/TNktAVUfXinznHYZPNAIDf8uXPeoWQijffYWxQvFnQmoWfdvoYUi0aihRI7JkDG1Ord4M9pizeYw6Im3/8GyeI/ds9aZLqKvkjg2N3TlxbAoxr+3ZPTkH4cD4+JoxIg/Px1pknQzVizjrReAB7ETpM1HLLZhOuJSvj+Egfey3CMKO57zWP2yeXbW2aZM32mQbIFPMWc2DL36oYIkaSzybmP9dfkCotjmQx4uxlM7bfBvZQDcuTedu9bpPUzA+ZiBL9hofiuhbcMQktZNmYaS1+nId+6A/IEa6CiiTQmzFDFon3uLoLTH9DKYyj8pxbLFkO8OgNtt2nKJHelbTbiu2Iyx6opbhaZ9CTCUtRSUIZGtKlDnCIjtK2mo/npMm1AwSkmjHJnXjU7q/e11o0kmjlC04Qgk54JvbQ7hJRT2FD2TJ1uyMZNlqkkCH4rXXtdL3LysIo72uPyJz/uNUF3DED8v9LQrX4KA29IBF+XQaAKExp2wVpTnWji/loNODpxg+y/j+eZN+t0rR93qcOy7wpoY7UBhcIy00G7N1fCpg7sWFQCJ6VyjKpswjfZUdGC1Dwd3OG8S+Y2/x5eAtPnDONNAwEC6f1V7p4c6rcCfljwnYREWfGfL4qjmiWRaapYrtQooWJn572wdV8WSR3O+KZcSQSalz+sROsxt8mvmmKAnP7VCKpMvMyH1xDnQ843YSQXFBksdtB9XliRmwScYxR+H2/M3aiYJ1lXcrpozrfz3TjmF2B1LT6YvLKAnt5lP4Efz+LA0tg==
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef27721-0436-465b-c022-08dad414c067
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 03:24:41.8649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ip6fqeLgT4zsec/1u8YzIp2IDSCj3Yc5mfkHtkb0vwIzTBdXeIVLeusvinsWXWKoQJf4kJ+k0AmitRI4Woz8Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR04MB6753
X-Proofpoint-GUID: dTmybHjDW28PpnYbqsLgTakqXHUSOCdF
X-Proofpoint-ORIG-GUID: dTmybHjDW28PpnYbqsLgTakqXHUSOCdF
X-Sony-Outbound-GUID: dTmybHjDW28PpnYbqsLgTakqXHUSOCdF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_14,2022-12-01_01,2022-06-22_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Specify exact file operation strings for 'readwrite' field in job file,
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
in job file 'rw' field. 'rw' and 'ioengine' must set to same value if
anyone is file operation string. 'rw' and 'ddir' string in log are also
file operation's.

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
 HOWTO.rst                        | 23 +++++++++++++++-------
 backend.c                        |  3 +++
 engines/fileoperations.c         |  7 +++----
 examples/filecreate-ioengine.fio |  1 +
 examples/filedelete-ioengine.fio |  1 +
 examples/filestat-ioengine.fio   |  1 +
 fio.1                            | 24 ++++++++++++++++-------
 fio.h                            |  1 +
 init.c                           | 33 ++++++++++++++++++++++++++++++++
 io_ddir.h                        | 26 +++++++++++++++++++++++--
 io_u.c                           |  7 ++++---
 iolog.c                          |  2 +-
 options.c                        | 12 ++++++++++++
 stat.c                           | 10 ++++++----
 stat.h                           |  1 +
 15 files changed, 124 insertions(+), 28 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index e796f961..30c49eb8 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -1137,6 +1137,12 @@ I/O type
 		**randtrimwrite**
 				Like trimwrite, but uses random offsets rather
 				than sequential writes.
+		**filecreate**
+				Create a batch of files. Must also set ``ioengine=3Dfilecreate``.
+		**filestat**
+				Stat a batch of files. Must also set ``ioengine=3Dfilestat``.
+		**filedelete**
+				Delete a batch of files. Must also set ``ioengine=3Dfiledelete``.
=20
 	Fio defaults to read if the option is not specified.  For the mixed I/O
 	types, the default is to split them 50/50.  For certain types of I/O the
@@ -2124,18 +2130,21 @@ I/O engine
 			details of writing an external I/O engine.
=20
 		**filecreate**
-			Simply create the files and do no I/O to them.  You still need to
-			set  `filesize` so that all the accounting still occurs, but no
-			actual I/O will be done other than creating the file.
+			Simply create the files and do no I/O to them. Must also set
+			``readwrite=3Dfilecreate``. You still need to set  `filesize` so
+			that all the accounting still occurs, but no actual I/O will
+			be done other than creating the file.
=20
 		**filestat**
-			Simply do stat() and do no I/O to the file. You need to set 'filesize'
-			and 'nrfiles', so that files will be created.
+			Simply do stat() and do no I/O to the file. Must also set
+			``readwrite=3Dfilestat``. You need to set `filesize` and `nrfiles`,
+			so that files will be created.
 			This engine is to measure file lookup and meta data access.
=20
 		**filedelete**
-			Simply delete the files by unlink() and do no I/O to them. You need to =
set 'filesize'
-			and 'nrfiles', so that the files will be created.
+			Simply delete the files by unlink() and do no I/O to them.
+			Must also set ``readwrite=3Dfiledelete``. You need to set `filesize`
+			and `nrfiles`, so that the files will be created.
 			This engine is to measure file delete.
=20
 		**libpmem**
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
index 9e33c9e1..d2a65a5c 100644
--- a/fio.1
+++ b/fio.1
@@ -909,6 +909,16 @@ other Fio options limiting the total bytes or number o=
f I/O's.
 Like
 .B trimwrite ,
 but uses random offsets rather than sequential writes.
+.TP
+.B filecreate
+Create a batch of files. Must also set `ioengine=3Dfilecreate`.
+.TP
+.B filestat
+Stat a batch of files. Must also set `ioengine=3Dfilestat`.
+.TP
+.B filedelete
+Delete a batch of files. Must also set `ioengine=3Dfiledelete`.
+.TP
 .RE
 .P
 Fio defaults to read if the option is not specified. For the mixed I/O
@@ -1925,18 +1935,18 @@ absolute or relative. See `engines/skeleton_externa=
l.c' in the fio source for
 details of writing an external I/O engine.
 .TP
 .B filecreate
-Simply create the files and do no I/O to them.  You still need to set
-\fBfilesize\fR so that all the accounting still occurs, but no actual I/O =
will be
-done other than creating the file.
+Simply create the files and do no I/O to them. Must also set `readwrite=3D=
filecreate`.
+You still need to set \fBfilesize\fR so that all the accounting still occu=
rs,
+but no actual I/O will be done other than creating the file.
 .TP
 .B filestat
-Simply do stat() and do no I/O to the file. You need to set 'filesize'
-and 'nrfiles', so that files will be created.
+Simply do stat() and do no I/O to the file. Must also set `readwrite=3Dfil=
estat`.
+You need to set \fBfilesize\fR and \fBnrfiles\fR, so that files will be cr=
eated.
 This engine is to measure file lookup and meta data access.
 .TP
 .B filedelete
-Simply delete files by unlink() and do no I/O to the file. You need to set=
 'filesize'
-and 'nrfiles', so that files will be created.
+Simply delete files by unlink() and do no I/O to the file. Must also set `=
readwrite=3Dfiledelete`.
+You need to set \fBfilesize\fR and \fBnrfiles\fR, so that files will be cr=
eated.
 This engine is to measure file delete.
 .TP
 .B libpmem
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
diff --git a/init.c b/init.c
index f6a8056a..ac316f85 100644
--- a/init.c
+++ b/init.c
@@ -603,6 +603,30 @@ static unsigned int gcd(unsigned int m, unsigned int n=
)
 	return gcd(n, m % n);
 }
=20
+static int is_engine(struct thread_data *td, const char *engine)
+{
+	return !strcmp(td->o.ioengine, engine);
+}
+
+/*
+ * Check whether td->o.td_ddir and td->o.ioengine are paired
+ * td_ddir and ioengine must set to same if anyone is file
+ * operation.
+ */
+static int is_file_operation_options_correct(struct thread_data *td)
+{
+	if (((td_filecreate(td) && !is_engine(td, "filecreate")) ||
+	     (!td_filecreate(td) && is_engine(td, "filecreate"))) ||
+		 ((td_filestat(td) && !is_engine(td, "filestat")) ||
+		 (!td_filestat(td) && is_engine(td, "filestat"))) ||
+		 ((td_filedelete(td) && !is_engine(td, "filedelete")) ||
+		 (!td_filedelete(td) && is_engine(td, "filedelete")))) {
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * Lazy way of fixing up options that depend on each other. We could also
  * define option callback handlers, but this is easier.
@@ -618,6 +642,15 @@ static int fixup_options(struct thread_data *td)
 		ret |=3D 1;
 	}
=20
+    /*
+     * return error if readwrite and ioengine are not paired
+     */
+	if (!is_file_operation_options_correct(td)) {
+		log_err("ioengine and readwrite must set to same value if run file opera=
tion measurement.\n"
+				"current ioengine=3D%s, readwrite =3D %s\n", td->o.ioengine, ddir_str(=
td->o.td_ddir));
+		ret |=3D1;
+	}
+
 #ifndef CONFIG_PSHARED
 	if (!o->use_thread) {
 		log_info("fio: this platform does not support process shared"
diff --git a/io_ddir.h b/io_ddir.h
index 217eb628..3c1ff4cb 100644
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
+#define DDIR_FILE_OP_MASK	(1 << 4)
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
index b963973a..cad18817 100644
--- a/stat.c
+++ b/stat.c
@@ -530,12 +530,12 @@ static void show_ddir_status(struct group_run_stats *=
rs, struct thread_stat *ts,
 	if (ddir_sync(ddir)) {
 		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
 			log_buf(out, "  %s:\n", "fsync/fdatasync/sync_file_range");
-			display_lat(io_ddir_name(ddir), min, max, mean, dev, out);
+			display_lat(io_ddir_name(ddir | ts->file_op_flag), min, max, mean, dev,=
 out);
 			show_clat_percentiles(ts->io_u_sync_plat,
 						ts->sync_stat.samples,
 						ts->percentile_list,
 						ts->percentile_precision,
-						io_ddir_name(ddir), out);
+						io_ddir_name(ddir | ts->file_op_flag), out);
 		}
 		return;
 	}
@@ -569,7 +569,7 @@ static void show_ddir_status(struct group_run_stats *rs=
, struct thread_stat *ts,
 	}
=20
 	log_buf(out, "  %s: IOPS=3D%s, BW=3D%s (%s)(%s/%llumsec)%s\n",
-			(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir=
),
+			(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir=
 | ts->file_op_flag),
 			iops_p, bw_p, bw_p_alt, io_p,
 			(unsigned long long) ts->runtime[ddir],
 			post_st ? : "");
@@ -1449,7 +1449,7 @@ static void add_ddir_status_json(struct thread_stat *=
ts,
=20
 	dir_object =3D json_create_object();
 	json_object_add_value_object(parent,
-		(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir)=
, dir_object);
+		(ts->unified_rw_rep =3D=3D UNIFIED_MIXED) ? "mixed" : io_ddir_name(ddir =
| ts->file_op_flag), dir_object);
=20
 	if (ddir_rw(ddir)) {
 		bw_bytes =3D 0;
@@ -2487,6 +2487,8 @@ void __show_run_stats(void)
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

