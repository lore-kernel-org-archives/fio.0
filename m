Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BBBC433FE
	for <fio@archiver.kernel.org>; Sat, 20 Nov 2021 02:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhKTCLw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 19 Nov 2021 21:11:52 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19124 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbhKTCLv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Nov 2021 21:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637374128; x=1668910128;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=HxyiUIDrwZ78ibSdAcov1si1azyIZWv2di4oKjlTI5I=;
  b=SXdxt1j9CNZsW5l+fVSUliRbj2zFbiFz2iN9aNhQqnNRX44yC7DCTt02
   KEVIBhyPapS232hIVAo6+cOxin8ELe9eH3feXbDfGmJJGR42KGdxi12U9
   f696Wyc0/xUQAuklTLvfDtTBlYm3qoS1XJTEfFRzcug2Sgq9gXdtumB6d
   eTm5C5TfwcqQerSrai095FzQmTUn0HO0zPgxn8ibwUGkTqLhlaK4uGVzQ
   lCPv01SpTtwrMjtBeVJr2gesJP7H0NYSNrUfgC1BSIKkVpBxbK1DmJY+E
   372jxe2tCt0954O1ybLjDpY+acCbQU1ozHAxiZ3Ri+BWI5ugsc3b7Z/0L
   g==;
X-IronPort-AV: E=Sophos;i="5.87,249,1631548800"; 
   d="scan'208";a="190965461"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2021 10:08:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvDm7rMt3LFMcnqN4KAHG5q7/4oAclTVAWEybqIHO1TcJE2m2nNrhQMPw4Bu9FXO6bH6ByLbrdbJP9odrlOnDHvjSfC6vLsWtj20neLUNEKV6NLOu26aYi9ISex976zQSIfCUu6TeG9Mj/dCTxG0k09/wHTsCTiXHr1aUMc6Io3vjKbx5cuhBXk/a6s8k54Y09bxPVFUJbfX6PiqsR8DHPlguXXf+ObKlh7bZvduOIS4B3etK4sY01dDKIxHTQy9GwhPpN98q1QUgGd8z6mKP1wVm+sBAUb2WcPDa9JuGj4dq3Q+w8XC3esnh9T3HqOyu4QS4ok9x1Lc32SgjcEzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYHkE172JvpXmTgUSm+yg5IUFKNjtUjR9YuQoxUP/Ns=;
 b=O7TSGiqY3EtApp5SAk1hh2P+AYTJpaMIyaTLvmIr8nYD11L2932mICwkI4726MLawMY7bTfEpYHKF8bv2fW99LT+HHFh77wAL1ZGzx3ph7cA4L3FmyRfu4wtMFg8CS/L8pBIcuBkD08A78PtAhQcg5nacccmnGnQxl22/P3qlmXaEd/nuQW2xV+HNPj4mOUTBpvZtncTvT8bPoWxqipyYWgSpf7sMPhFEucgkMTS0VOzZ+buOCHxLV1qrO/+T4uICVYAhc7x0FhVzYDnI2j+emAJVxDuWsLjmGHfIn0URVlc9qIoU32gD0TgFj+UIRgj8GWSwcem81nafd2z7GAeNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYHkE172JvpXmTgUSm+yg5IUFKNjtUjR9YuQoxUP/Ns=;
 b=VEOffTp1tI3Qixf18fD0ZzNdDMqlmHBjgBFbx9bsoBLH7krAm4vEKfO61i94mgSRtNaEpucriKkxvzouCZShj/hCpwL7VgVPaqLAfIT6K/Y41kG/KBpQ/RuzZa647yk3KYiBollzRn1WYXxhfiQEsYUNF0iaC7z4uQaOnfd0yro=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 02:08:46 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.022; Sat, 20 Nov 2021
 02:08:46 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 0/5] cleanup clat prio stat handling
Thread-Topic: [PATCH 0/5] cleanup clat prio stat handling
Thread-Index: AQHX3bOMLliyHzGeUkOReeO3LjUPMA==
Date:   Sat, 20 Nov 2021 02:08:45 +0000
Message-ID: <20211120020837.127453-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2b681f9-e5e4-4859-dab7-08d9abcaaf43
x-ms-traffictypediagnostic: PH0PR04MB7622:
x-microsoft-antispam-prvs: <PH0PR04MB762253E088ED285A73C75AD3F29D9@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZgUFjP0QmVpHy7k351IrDaareanrMaMTrw2uiz4TJziOdsSO+5p12OLPNp30+Yw04zXMob4e4opUwiGlN8EWPyyory+v6o12ZDol3niNGMSXsZxhe6Utih72vZFkqp7YpuEvLL7UD2CN+Yi7C3JkR7Hq82i5U/7avVjLgfTNgwEiv+m7pWNJjFWUOzE9BeGiNTdf3l7xH7wR7VJ7FtJBEt4iGNfuc9bhQpJgQ2KtS78ZmU7juVvmf6P8Nc9GkTXlHcdrsBIxA4ldLPLVBjq+dRjEFIIyiQxgy4BVQ+Ki8/oF5HBZ1iH9K33XZ+87DLnZKbS5jq61rJEoPg33R9Ziymmq6f8nPg9+BXztGdwGzQ9VwO/kRuSouuDlb2h8buHW7SPwUHwv4VWvPkehLYcpAanMeg9kFxhq91ZsS9t8rzCKQnm8pEIzkzmHkwjtZ2p6ORff8v5sgQ+2eMG0LCvjVgbLVwcpQ8a68zmGVLLivaHgSXRnOVyDWzRw/hoQlqoOOeDDn8rXZoC6102tLjKBhAg2tRzSBoiykov+6blsEiocovxY64BtlWT1abncBcD4Y6e9oUM9eaJRX90ym8SD84iDLVjhxmuuooo4jpaE2YPGW/EL0Ezn3E3a+JxTTvqTzt7gLNL3YeHAXewBSGJyi1l/9IFH7UxZWCIr+sp8uMZHj4fUUmQC0wIrUPhx6X/xfpDd1NAitnY+lt+gxaaA8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(8936002)(4326008)(38070700005)(8676002)(1076003)(26005)(86362001)(2906002)(91956017)(76116006)(66446008)(66556008)(64756008)(5660300002)(66476007)(186003)(66946007)(6512007)(6916009)(71200400001)(508600001)(316002)(36756003)(6486002)(2616005)(122000001)(83380400001)(38100700002)(4744005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?dr1AovLKggvqY3ubXUT3e7c2eLIDdbLtdRL/ezeTFoeC9oT05t2/DxAFRp?=
 =?iso-8859-1?Q?0odi70YlxHQh7ARu2xkNGAz7elvGTmSaHb4QtGc2+uy9HhZ/RdMwj8Wctl?=
 =?iso-8859-1?Q?tYVsrAj9XyoX9iQoYlZUNwltahct+7YZuhPLyEIMa4rkssUUQcizehFCPZ?=
 =?iso-8859-1?Q?+m8khDaBeH3o5ELEnHzQQI2XaqhMc/VpwIPFCA951v15X5N/xLaCOz4LWH?=
 =?iso-8859-1?Q?2R+810gmxjzom8L2e5FIUVcPmUv3DmA1dONKtvhLhGJFe+83sa/AjNmU3a?=
 =?iso-8859-1?Q?GKxCLw/fmLkXiZ/vzLa7R+FV0CtZnHQRWZMYoaeZIoIknjDhNn+YFkyHt1?=
 =?iso-8859-1?Q?dyH35xrJGjj1ACjwe+5OyK7FGFhzDACuOVKMy9S+l0ZWS2L0DJLN+DgpTQ?=
 =?iso-8859-1?Q?Ax+Z2gZ5HhVs9ivYeHKXR97RvMNfPT8o6kt2BqHLf8Rq82Q0aU9C/xmyZc?=
 =?iso-8859-1?Q?dXBxbuUQ0FPZ6ngWlf2OqV054jHl826miUvhCwxBfm8OYpQhQV7oCT4/Dt?=
 =?iso-8859-1?Q?dVm6G5bUhjJeHLVhrBpHAZMSioHmzVXtXczCbd9JwY3kLPUerrQetZL/OB?=
 =?iso-8859-1?Q?rcNoe78V2F9ntw8eLQsvsB9l1umEz/JFkkenYlFcuwDm/GRmgS37Vzt6V6?=
 =?iso-8859-1?Q?PLyUDbVPB7oMPLAZEux76hx1FcSBrarZnTFIhZbY0tF3vxJARHOTb+6aEp?=
 =?iso-8859-1?Q?8+uwEhRyr9ZcIOjJw/E2gGMfm5ZKe9JY3w19UNJWtgg1Ydg+6fsci2lDwQ?=
 =?iso-8859-1?Q?Oj67ljwLiMAylb9obxIUOZZCavrEobp3/zjqHdQUuYwrexZS4aYT6BCMNn?=
 =?iso-8859-1?Q?7VwRaYSLc8kRz7ugkTGgFj+WfZIgKgJHwps4YbKFbOrWJ6avw9+kmFvXLg?=
 =?iso-8859-1?Q?8/Dxa91E3OxgccKvRExuVsd8YTCEuudPwxjRxrmNOWOkiDyNL/zm6u1Tiz?=
 =?iso-8859-1?Q?/xWNnmYjk5nYw4QzhxgBNOkC7zcHwXPnQaI8PVqHVTaI+GUgryHvxkiHmI?=
 =?iso-8859-1?Q?YalBr2cKYbkctP4L7toUFwTs+6xDn6RtcPR5+WSfYDEKZAuYD2breBV5uu?=
 =?iso-8859-1?Q?h9njX7FyXn2CXh2mV3byxNsJG4mOjiOTyKc8RS4Ch7LdezjNxF/EHH/F8J?=
 =?iso-8859-1?Q?buqeSm/IDZWR+HhLehrLq66+OyGuV8qx/MULnDEFzCUtp1nDvy1Q1vvdvT?=
 =?iso-8859-1?Q?N4I52yCyeLPcTOlxoz8YE7Sz3IFAcd3RBqjqv52fSnVxgaWGEjn9gpM4+0?=
 =?iso-8859-1?Q?xtdyWx/a/zz4gIV+niaA1m6ud2bxzol2ZgNJlFbye6wQ6oPjqjAn6dghrU?=
 =?iso-8859-1?Q?I3FyMFu5N2NLen0SgJwyFsEMMIqX0094sC0zfORdc7U5d5zqPgY1qkLs7o?=
 =?iso-8859-1?Q?GcrYN+QDTblum0Is21xWUVfsv7fYAceggaFetiAZjs8sHo1CKc/U38LDbS?=
 =?iso-8859-1?Q?fUUt6+J2h319vkBufIqMNkfXpQuAVdabCcQ+k/2U1hWXjfGnTBMcSxiUhy?=
 =?iso-8859-1?Q?C64J35Gq9VLHMOx7t32YoVzM8hP2FfYxgFrUeuj5GvNOwmtKCIH+UBO4PP?=
 =?iso-8859-1?Q?+CSFPomZeRbvO0jO9AP5qJ8pHEUnRpVxQ4yXr9Unw/Kl/jUMuoOnWBmxQn?=
 =?iso-8859-1?Q?hGeWxYDkTqa+VPVSX0zo9Jr0aQYngJnt5pP1zNnb8LXzXv3AhQA+18/G42?=
 =?iso-8859-1?Q?70mza17ZpqHf63X40mw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b681f9-e5e4-4859-dab7-08d9abcaaf43
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2021 02:08:45.9877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+FTBySmN3a4GQTApsK181ljxsrhYWxPlFyLXVNak8w0U1KTYF/Yowrqs1ppf3JyPJoJBqrUMi+Cag5WRNVuiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello Jens,

Please consider this minor series which cleans up the clat prio stat
handling in stat.c, in order to make it easier to comprehend.

Kind regards,
Niklas


Niklas Cassel (5):
  stat: rename add_lat_percentile_sample()
  stat: rename add_lat_percentile_sample_noprio()
  stat: simplify add_lat_percentile_prio_sample()
  stat: make add lat percentile functions inline
  stat: add comments describing the quirky behavior of clat prio samples

 stat.c | 53 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)

--=20
2.33.1
