Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1A1C433EF
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 20:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiEZUuT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 16:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349052AbiEZUtz (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 16:49:55 -0400
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [139.138.35.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89C5E64D8
        for <fio@vger.kernel.org>; Thu, 26 May 2022 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1653598194; x=1685134194;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=bqMCMsGFm9HN8/BB48WVwI7Mv21JqtTXUT6nfKeGJFM=;
  b=gOrAq2BhyHV1GEuctHD6VAWt+cS/ONsrm1xES4aCil4k0SVBORgjB3eG
   fgIXitUDg4zzm0w3c8dT1gVClq4JKJ7HKn/8NfNRM2ApGRw60MeWfhAo7
   X1DaRWIkuf0ONmF0L/xxMF/Jjxh58ckLLv+EMM7OSuqr/IvbdDehRxaWJ
   4=;
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2022 13:49:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StAsR/vn6qfWHsve6XX79jbvFSXLF4aEG7H+gaksJdyPy9FcFK2uEn5v0jxBKtGYGdmyzpMAepxcfOTSlmaVRSKkqtLGDWJyHDX8Jmcubz4haA1m7uKjOS270zApXm3DXW/OGpRp8h7kQXXuJVXY5CEnYFuG1WjTx820vut6vjiTmFis898N1lAnEawRld5aTG+woddzqEEMsWw7XYtpvIGYK0LS7whktOdUuMeuZ5m53Wge1KLUoRwznaUt5mZERs22zDdkl6ykT9qIkq+PxsEeEEjX0dQBy/o6h/+zfXigFmaqiCntqbMDCgBuC3c/JJyGOa1XNpfwYulzCaq45A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqMCMsGFm9HN8/BB48WVwI7Mv21JqtTXUT6nfKeGJFM=;
 b=LT0g3G+Gje+3+vxIKY4s0V9LcKeR0/wvG2kih8SVPsZ/mzqL9ysXAnaV8QansaAV4gD8KRpQam1cX4DY7WgOwIegZOBvDKOyPiGahyUJWE/ZB6gDgHy93j7uSIML5tRKDth0T8K+ID1BSILTKcfl4hhYlCQSgFHmDc+Zo15GPySiupcDz3Aenni0moAuYrtg0vcMGAxtiAyUeUN3J2rOIrwo/q0pOydNzesZsQSPNdgwRXqyUoims3gFmOiMXIJD0e9NoKqS3ffdrjs6yvZYWy8Ox4uo61pcMPDIBW5xBxYKSXd54796unCE8k9ak+MxjSsVxlZJruF1XkEjFUhXBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seagate.com; dmarc=pass action=none header.from=seagate.com;
 dkim=pass header.d=seagate.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqMCMsGFm9HN8/BB48WVwI7Mv21JqtTXUT6nfKeGJFM=;
 b=QmmIQha+V/afqTT161Aw1KHhgmTzy3ySwQqlyKN3hEbgAXwn8lm7jIUDP31AGGxI+/GVpqIm1ouW7N4KUM3sIexiG5UUMnHfZSwqtWyTs3Q/VMF2WMXptlHI2abxOI/4MxNzI5wq6EQFfciys3GEwhJVLJxAGTRIZU7yXCK3NPk=
Received: from SN1PR20MB2144.namprd20.prod.outlook.com (2603:10b6:802:30::29)
 by CH2PR20MB2982.namprd20.prod.outlook.com (2603:10b6:610:1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 20:49:50 +0000
Received: from SN1PR20MB2144.namprd20.prod.outlook.com
 ([fe80::f14e:2a77:639:398a]) by SN1PR20MB2144.namprd20.prod.outlook.com
 ([fe80::f14e:2a77:639:398a%7]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 20:49:50 +0000
From:   Phillip Chen <phillip.a.chen@seagate.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Global filename/job filename interaction
Thread-Topic: Global filename/job filename interaction
Thread-Index: AQHYcUGUCjTKnR8QjU+fYvsO4iFEEQ==
Date:   Thu, 26 May 2022 20:49:50 +0000
Message-ID: <SN1PR20MB2144FB2532E1C53EB311F737DCD99@SN1PR20MB2144.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Enabled=True;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_SiteId=d466216a-c643-434a-9c2e-057448c17cbe;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_SetDate=2022-05-26T20:49:49.941Z;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Name=Seagate
 Internal;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_ContentBits=0;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seagate.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 389829a7-dd4d-4bf3-c3f3-08da3f5946f1
x-ms-traffictypediagnostic: CH2PR20MB2982:EE_
x-microsoft-antispam-prvs: <CH2PR20MB298212674D82507DE7FC9CD0DCD99@CH2PR20MB2982.namprd20.prod.outlook.com>
stx-hosted-ironport-oubound: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uv/ITA4VHhu66GwopPkJNuVNfhQ2oE53QwPGtzorLwSYrTe20FTCiuW4N7/ttXQ6y+lO8MqFZWIbFZDsMjYF+xQY5uBhmVtIGhFnbAN1pEbWApyWUAvKQg0xD2vIFuiifXRd5bDQjhbYUuzegCnTR2lboXoopD9wU8FLygTrgSTGgzqkv5mjCGUVA39CWR/YGiSV+8dXis4cvS4Wt8AErM6pmgP+4XEgpxzTlWewqaWDHQkF3YtGy/o8+JfRkblt6jlaVQ4yNQJ8X+LsKst1Evy8elHqD0f8wih3flib+21OdqGqlsqpgOfOkxvybgrtAhm5lA3ziN9UTiWOJSigrvnoWgonEbwMJHn7uXY/XzZ117t7r4CmtqOFGuMAb1wY0gGWVYEpuMyvFI1/lRIHEUnc03qYu4kPX2v53XHphys3Z9L8PrPQQKVPGp0y9FMOSZyCcmtrJCh/cbk4oAz7lC4EoRr5RP6RvnBPrBGGEAfhFXs4l/G0e3idFs/mLjwG2YQgp8MWax6wcP4+qgE9dqgF/rXiL6ebQgg2TiA5o3aO+F3UygD4fc5T72fyCWP2o78rfhnIpjZFS8bBaxfZvKTLAOR3Hx4bdC9jMZoxGV2PSVhjCp6xB+sKTucBLyE2ixatb6C0hOBQxq3Y5AO+XgQ8kfqUu+cbQOHogDSgOC2DYRRwIG2D5TwfWxgu0K15t0hugtwTB5CUNj9H8c2tCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR20MB2144.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(52536014)(8936002)(6916009)(316002)(122000001)(38070700005)(86362001)(4744005)(2906002)(7696005)(9686003)(26005)(6506007)(55016003)(71200400001)(508600001)(3480700007)(66556008)(64756008)(33656002)(66446008)(66476007)(66946007)(76116006)(186003)(8676002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?V6PxaUrNACQDkMcE3H1N2qEalaRGXUYI2dtVQpaTzL70LMK/HT050S2Gs4?=
 =?iso-8859-1?Q?R/Dre6rxg3Wj6WOYBHkXK2D1MNq0wUdbBAl5dcIbHMpbmCzDL0sf1/9M4j?=
 =?iso-8859-1?Q?pr4TxCyB5S1tuaezkyPED8pddwaevom027NdRodrWHiAZ6SgE80rghAxUQ?=
 =?iso-8859-1?Q?REuw5+pdF+ed2Y1/Y/5EFVHGgaG5B97lddfEC5hyFr0Ydt8q5yRhUA7p3K?=
 =?iso-8859-1?Q?vu969PDP0B/CqCKtt1mTbKRJKWNRphZkzzCvkFbHFwk1X4RKe4G+Jzx6V/?=
 =?iso-8859-1?Q?/xAo3r1chC3lvBwbgVqBNwvpLLapCc0w9y/Fy/7Ax7Dfn/4SJHMY5lkjdZ?=
 =?iso-8859-1?Q?+wfNaipLxHQYMm+zi7WDAu4IfcIjXk6jxTYjConIWAVBEhJ9PSki//Pa+y?=
 =?iso-8859-1?Q?CoWj2poX+EoX6Qw7Xdc+F3sezFp7CI7qB9I/xOHKJx/OhbZdAt+dXk5BJh?=
 =?iso-8859-1?Q?5KRtwty4xIa0shGfah225kK7R4CdMUcnnld199Ky/62TymuLBMcDdqCvSP?=
 =?iso-8859-1?Q?Zlscbm1XRs53YKCnDt6F3bdfm8IyVk64Cy2Iq0MxKovkaN6BMoVfePYRpP?=
 =?iso-8859-1?Q?kU9IpOrFuOuFrICfx4cAknR4yvhnWHAvHP13Pe+vRQjy3stlVLaQsjiOkg?=
 =?iso-8859-1?Q?aPIdQTYUWBCr1XoGANMf3TU9YT5VTEpYEhIXoYr/MOeFgVONvgm6YaK87E?=
 =?iso-8859-1?Q?JDaMkJMyO77o5ki5OpSLtkfiJnw0NMHEMjZAB9wkUw6mrXmIi6F0gIOdzT?=
 =?iso-8859-1?Q?BpcTyVUYoIZOc1S5VaKfFxUvBLyWAJYmkn1XE2mCK3n9Yq31PTrnG4On9t?=
 =?iso-8859-1?Q?X/FdUI+x7lata4oJRninDBfcU6dIZBuDQSuM1bwjwppTbzZgMwugFZznbS?=
 =?iso-8859-1?Q?Lra1Z77EZuto0f/atH3LI5imwhzOn9VC94t/te7aRUw60wbCcxz7A65Rzt?=
 =?iso-8859-1?Q?JeaZOo36rmvFRQl3A9VfB41krcZUD3DEd5/pdPkp57/OYR/Y71fXSMz8dJ?=
 =?iso-8859-1?Q?lCC/oBlCsS9t86WpR8IFxY18SJCe7sULcrl1vFRatd9UibXTKAFp2byL1p?=
 =?iso-8859-1?Q?w2ae9ahkeCDLHOSfm/uL7Nnvug27XGMIg8rGT2K3U6vRi8kBDbU8Q2SNFc?=
 =?iso-8859-1?Q?O2sOXpitmydkS1WoGEIOHjUlH+kkNDTGL5ew25/9+0CI31oaLWaoU+lAYT?=
 =?iso-8859-1?Q?Ji9WGuVw+x6W7fQK42xWbeG3XkFpGsgh0xb/5m/Ijrr7r8IY6YL3OUDS99?=
 =?iso-8859-1?Q?uAgFQ+0VC/RIzDfe1y23JewIBwKAVU/ZW1c78Vusabd1ZpgJHq9nEhAOgD?=
 =?iso-8859-1?Q?+uVC/T0sH9rb+OHC29TXOb8C8dzvPKvN/+cSBC+Oj8sjB8/uyQYfHH3PEt?=
 =?iso-8859-1?Q?RWXasWhyrfinicMTu5+/k6Ey6XBmLGLIyrxyFEE32LnhQbiOptpmXrcZwg?=
 =?iso-8859-1?Q?zqquuF9PVRYSN6KbhGYeY2Hzokv6e2maCtlpZEqKXpPjdRAS+iBFKJ37or?=
 =?iso-8859-1?Q?oXI5/DQeC5H+N9g6Le5SdabgZv18IKB4waC5qH/3lETMF0vsbX1ub5Pem4?=
 =?iso-8859-1?Q?G3EekKU5e3vz80GsQxaM4ijJPkdXilc4Fqj2KApf92rCxv3iKg4mwtgmVg?=
 =?iso-8859-1?Q?A3beJt6YC4YJenwrx8yFIBoY8l+S/iKKvxS3DI2nTxmdQsQDm72FcWrqiH?=
 =?iso-8859-1?Q?4cQid5yc9rtdpCMs/21dIUpuCDmH3BllORPkxl2AULQjcC6r5TWUxx2z9A?=
 =?iso-8859-1?Q?mjM0XJLIPjjl4DLkwXA1Fflksx6OTxXyGta7ExH62k3gGlkuqNeRs5n87N?=
 =?iso-8859-1?Q?+6UEHHPi2fKR9b7zyctfDZJz7dOR0EA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN1PR20MB2144.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389829a7-dd4d-4bf3-c3f3-08da3f5946f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 20:49:50.0610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mvG+a8cGv6oa0vOb1bY0lKikmQtRGd5k2vbZcECwc9C3q4pkFkU4J4iUgaui96+aMbl6Rwz1G5uf4NvHCPF54B7YoVjzKeDjl1LUgU93i+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR20MB2982
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello,
I was surprised to find that global filenames are added to job filenames ra=
ther than being replaced by job filenames. For instance, running
fio --ioengine=3Dlibaio --io_size=3D40k --readwrite=3Drandread --filename=
=3D/dev/sdd --direct=3D1 --exitall --debug=3Dio --name=3Dsdb_randread_1_4k =
--filename=3D/dev/sdb
with fio-3.30 will show reads to both /dev/sdb and /dev/sdd. Is this expect=
ed behaviour? And are there other parameters that work in this way? I could=
n't find anything in the job file parameters documentation mentioning this =
behaviour, but perhaps I was looking in the wrong place or missed it.
Thank you for your attention,
Phillip Chen

Seagate Internal
