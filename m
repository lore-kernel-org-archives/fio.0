Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37315C433F5
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 23:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiASXNV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 18:13:21 -0500
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:3602 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240071AbiASXNT (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 19 Jan 2022 18:13:19 -0500
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20JLWClo017445;
        Wed, 19 Jan 2022 23:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=TqTiKqGRgkRCEKbA296tPEo8Ce+GJ4J2WkKEAUFQ8Is=;
 b=cBjt7PFrx9vvE0X8wwMjqnWB7VPQyibYNqV2nhZJfvI5JG6JLAo4k24cGvCYkR8JOvoS
 SmIcZGA1WrBx0GxSUz5Jv0lj63Lr3esuk82UR79lJQ1mnhaVMcfQin6F6i05qYJy6N/2
 gCVn7RIQmyuruaT+u2P9IYJ8TyIzSQyacdAhAvQF6+9umEyLvjQs6jXc162GnVwrEPQW
 eQWAgWHKM8LhF8EL9q47kTtIquerzYvnk4XIDCZZmSZW5rEqnCCyM/WQevUh1DUNsZer
 dEzvjlad6JSytwxI5AHYY558OpAGOVNcW/VTN4rR/znHPoD+h12QqvCulgbHd5CZwWXe FQ== 
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3dpqn2jbay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 23:13:17 +0000
Received: from G9W8455.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net [16.216.161.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2352.austin.hpe.com (Postfix) with ESMTPS id C9D0991;
        Wed, 19 Jan 2022 23:13:16 +0000 (UTC)
Received: from G4W9119.americas.hpqcorp.net (2002:10d2:14d6::10d2:14d6) by
 G9W8455.americas.hpqcorp.net (2002:10d8:a15e::10d8:a15e) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 19 Jan 2022 23:13:16 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (15.241.52.12) by
 G4W9119.americas.hpqcorp.net (16.210.20.214) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Wed, 19 Jan 2022 23:13:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muTD0GKGJUlujR3rTaFTJE2yTBsgPjXMHdEFz6nnItZKoK/6FMUP9w5m3+A+lD7C5KcEh7MhCr05h94arIk0f3xbKEeTIJ1LyvNuIspBv1v1M+t5Za5RcG4H0NHQQ3LpOqRiNu310EAca2hiuMFaHTle1u5r+qF9c3xN1DmS2cPhjOFaWzKtS7vVDdnnSWI4e1aIIAKLysCCc7Ue2BvrgyCasic+VL55UuQCZSegkScPEgrK2oy6ntQX5TiudEityn6Iiw2h4wSZ2943GP44SibIZFr+JSua1WWgcqwJnA/MrIXBrDEhMOiq4NuqOu8FLt2tEhs9PzA1wuSR+IW4jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqTiKqGRgkRCEKbA296tPEo8Ce+GJ4J2WkKEAUFQ8Is=;
 b=lebEdp9yTE9golzVlv/V59y2bIiiqG658jFssUqPGm6GXGgqIqHHpLDJVParQbcfnhgmZ3wGa2gEk580tkz625YkVJMaPhZvEVdAdWIZvgbXpZEvqEO8WNcn761/QKW3juGCBFvH4GPP+4H0dT6Tbs/Vyx48A7jscAcosHHd1OJMgwCFRdUMYOY/TQRIhDSh3MOPZiDLeW4kuUxd50PtbvYE4mxAhFz7BQAdsMXykVEt14HLN1NtQifWL+qmzsUiOJn56TRjcv7UCbO/nKvIjSEK8NLoLbq0l8KTBtnii3XH3F6fwtQfGBK4dgroPpbmrrwHOkErqZ4aYCHmDVsCzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:430::10)
 by SJ0PR84MB1723.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:432::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 23:13:15 +0000
Received: from SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5412:9971:9c86:1e74]) by SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::5412:9971:9c86:1e74%7]) with mapi id 15.20.4888.013; Wed, 19 Jan 2022
 23:13:15 +0000
From:   "Gibson, Thomas" <thomas.gibson@hpe.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: re; How do <>rw and <>rd_wr disk tests work?
Thread-Topic: re; How do <>rw and <>rd_wr disk tests work?
Thread-Index: AdgMrta5hWw6IKUfQBycPuSE/E9kIAAE5xEAAAH8y4A=
Date:   Wed, 19 Jan 2022 23:13:14 +0000
Message-ID: <SJ0PR84MB1434AE19C05D674BFB9DF304F4599@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
References: <SJ0PR84MB1434C484CDB0DE5E4A19554BF4589@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
 <3422d44d-15e4-1e23-d2e9-70477039ca3a@opensource.wdc.com>
In-Reply-To: <3422d44d-15e4-1e23-d2e9-70477039ca3a@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e1ac99b-80a0-4cd7-8998-08d9dba14577
x-ms-traffictypediagnostic: SJ0PR84MB1723:EE_
x-microsoft-antispam-prvs: <SJ0PR84MB1723FD51B8DD19BB48E173B2F4599@SJ0PR84MB1723.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DYuY2njAtS63hHKEgqtxo0C52Gk1ppoIT70psvPLh8IZsCZkA1dv++htmnAFAHdoJLdLg+vqigxz+mFHQ5VDFOEPsGstG3q1k2mAs/Xnv8FF6aD5WNzzzm0E93F3ZWm0Ftr7fQoPCnH6U8mVTQZhGBAKOrW4lKIxARoxH/dDN9Cuu0Z0iCiwxM8r7pMInHHechdXR4NBdRdbpaP+anr3myELPYgbZZCY+UEZ4jzfNuvlssSc7sIi1mr7PMR2mSaikcuYfTpyJXRlspp5y0yVfOzmLJHEWk/PTwEJeXQCR0oqkHlq9SaSJxESI5nVHZ0WF3JGfB0dRfPlSFSWhTayxroJLxlVaoR6n4jHoQArzq6Vmi1JFQzN5GFWRqhoMoIXYMyhxALc3RxIQVbypFMPZCDhoRolH4/qOFvs8vxWMEVI6XS6/3FbPPEycizbr6NeO8iTExaVP6L2Ntj6U7wv4geDAB5utEYV5jybcbwE+e2jURWsAU1LwnhkyUQgXJqPJe9a0knp7xrsJij04gBAmUYl4s5NMVueveFT1sWMLYnhqhz7OfWIwhlrod1RrBosECgzdQf63VJT+WoOzFJQMx5rJsPNW1iGkZdC0eobGWUxmuljunJn3SnINZFH4IJxFlPIOkbTu1QEMRfAp5I7qFY1ZsAe+wK/sGzjdwd6gLy39fEapC0bhc6/h0bz3btGxBLKxn3tyJ4tG46tMKDCuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(9686003)(66556008)(66446008)(52536014)(66476007)(2906002)(55016003)(38070700005)(83380400001)(8936002)(8676002)(38100700002)(64756008)(110136005)(82960400001)(66946007)(71200400001)(86362001)(122000001)(6506007)(5660300002)(316002)(76116006)(7696005)(186003)(53546011)(33656002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHBiOVVIYTdGWTg2aS90NEJlNk1OODI5bVoyZzc4cE5SUllIMGN5SEtKOUJl?=
 =?utf-8?B?VFBHM3ovZlV4V3ZnUTluaDdvVXh6WTRBRFJXTzdBQ29DZFkwS3FEL1dsL1hN?=
 =?utf-8?B?Tk9hMmJIdmR6dUEra2ZPZUJ1N1FCYkdPbXgwV2UrK21Yd245SU94NHRIOUU2?=
 =?utf-8?B?dnlYQy90TEU5VklyVEEvdnFzMFhPaU9NRERPQ1pzTUNoVStQSGkzcE1jTHc4?=
 =?utf-8?B?Mk1VRmhmNTJJWGpiTDVBODgxZFlpYUpsUExVYnJtcnZVVSs3bU9sVHhWTC8w?=
 =?utf-8?B?UE5tYUdlMmxXdkFNRUdNMVpHT0d4QzdES3ljSEtxaC8yMERqU3c0MWtHU1dL?=
 =?utf-8?B?TTVFdGZSMzRPRDFjZHdpZVQ5UTUzK1ZTN3ZWZ2JwOE84K29VaXFtRXJYMVRk?=
 =?utf-8?B?UzVCWlA0eHJTOEJJQzJRRndiMEpyWUhTbjBHOVN3N1RxVXZaSEhUdlhOOEox?=
 =?utf-8?B?Qjd5Z2xMRjlCMVRkdi95amxENmYrbmowLzBMQ1VtUkMwYmpnbHlQVXRRZU5L?=
 =?utf-8?B?ZkRkYzErUk5KWmFqSGVzK0paRnBob3JkektabitpQ2RVMzZ4TU9GM0c4WkxJ?=
 =?utf-8?B?alhHMEs2QVVLT1F6WVRQNXRoSzUrT1ZBWSswaUhhQTFuWGhxb0hCNmJPVVlO?=
 =?utf-8?B?KytzRkk3dXVnK0N5V245cnFoeFZydnVUUlBZanVETHVVRlRRSXlNVmltbUdt?=
 =?utf-8?B?WG9zQTV6OWZuTG1OOHlhSjZpdkgyVzNjY1dpQTRXSndqVVJXYmJJaFFkVkhC?=
 =?utf-8?B?cHVjanRBeUEyQUtoT01DcFpnVlhVa080dWp2emFTbjUrSG9kMFRnK01hek9S?=
 =?utf-8?B?NGxqSlZFSi9yUkc4NzRQZEI1NS9JMlZ0R2s2dXBtUUJBZll5azliSzZYSE03?=
 =?utf-8?B?c3FndzVzdFl3TkQwYzIvUFp3YWZHYTUrUkUwUVVXcHBIMHd4ZTd1NXJVSzla?=
 =?utf-8?B?VUY0YTIvSWRic1BjUXRaWXRwT1dnbGF1TU5YQW5hYVI2bytLU2RkWkRVeHdV?=
 =?utf-8?B?R3JRc2Y0ZkVGLyt4ajhKcHYxRjNlUmpGeW9PT0FaMi9sYmFkZVpWM1dZMFRa?=
 =?utf-8?B?cVpLaTlsNzRtVXNuSk9nRFo1UHNMd3IxR0dpOFpTdnRhVDdMbktuQmlmZkU0?=
 =?utf-8?B?OGIxVjNUTi9pZHlWUmtnSC9xZHAyelJjMjVUOS9ndGJGN1FPeEFSRmplbG5z?=
 =?utf-8?B?Vm9DZXlhSnBNYllNM3gwT05TWGlvbXE1K1FXNTNWYXEra1dZY3lUVjVZcm9X?=
 =?utf-8?B?OEFyd0EyZytVNThvdktBb0ZBbWpNTzdpMFAwcDk5cHR3d3Z5WVllU1pvNmdl?=
 =?utf-8?B?eGxSNmNzNlNCOCtxMUtDeldLZzR2SkdmWFhEL0poV0ZDbHlrZ0tUNHlJWEZK?=
 =?utf-8?B?SW1HU0hBanZaWVhPUDFqam5iOHh3dC96bVlFeGVjTHhlN3JuZWkrb2xsMllm?=
 =?utf-8?B?V1VMNWFIcHV5VFVpT1FtdDk3dDgvWVNOajlCc1VseHAxdGliYW9OL3RFSXFD?=
 =?utf-8?B?M1VNNS9SRG5KUkg3Z2ZZbm1ZTEliMEEyeHhiOGlsQmY5WG5VTUkrMm1WN21R?=
 =?utf-8?B?ZGlsVytxUW1tVVVqTmhJZC96WThwSUt4akE4aWJOVnpzV0syOTlZN3dTcUZp?=
 =?utf-8?B?WUJJcHhYWTluRjY3TGNsV05EdURRc0wwWnBqdTB3N2wzTUZ4LzFuMEI2akdm?=
 =?utf-8?B?RVUvajBmS0lJQlVqQW96YTFodmVMT2c4elAvUEF6VUJwbnlLVkdURjE3SldY?=
 =?utf-8?B?RVpkWVZHd3R3cjhydGprc3BrRjZ0NmdzMUptMEtSMVoyTnNlanZtY29IUzlZ?=
 =?utf-8?B?cFJmaFhpcTV1TEhkWUhla0ZXb0J1RUdBbjhJSjhBRzdxTEZXVU9abEVOclRS?=
 =?utf-8?B?cFE5bFNyZG01Y203UFFWQThWUHpURnpDVVJnbHltNEdPZkdZcXJuOE0zcUVn?=
 =?utf-8?B?eHUxUEs1MVlQczB6QXJkczVlVzgxdEtTbVR0clpEcW00dmNqUW5zUDFjSkJI?=
 =?utf-8?B?TGF2VXVQUEZ2TnBOSys4eldRUEEwK1JONlJnREgyKzZCMVpHMWlSZC85UXh6?=
 =?utf-8?B?VzdmaU15eDl1VTUwUWl0cU81ZmRFa2RvQVFmY2tRSjJtcVFTRSs1WUVmaVlY?=
 =?utf-8?B?YjRLK2NNT0dCUGQwMWVVK0pvOTJSVGhoVU1CRWFsSi81SzVjME9YTlUySndN?=
 =?utf-8?B?N0pvdWtFYXlLME9TdWo4NmVSMmhjZkFyV3BEWGxPQ214YmlXc2lSMGJSUGpw?=
 =?utf-8?Q?PbGjOcLEvM7ifvz/KIryg3JuBbywFYLNg/TzR+slcA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1ac99b-80a0-4cd7-8998-08d9dba14577
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 23:13:14.9597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IV7286iukhUN0fdslsVmKEszGad+Q6W7ee1I2akZTIwr7Dy0car2mLknp8oIUKWMeE4Gt7MqM8qt87RdjZlhrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB1723
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: zmTkFQI4YcJbgQFNr8m9GCYRtDoRKc2l
X-Proofpoint-ORIG-GUID: zmTkFQI4YcJbgQFNr8m9GCYRtDoRKc2l
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_12,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190123
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SSd2ZSBmb3VuZCBzb21lb25lIHdobydzIGdvaW5nIHRvIGdldCBtZSBhIHJhbmdlIG9mIHRoZSBK
RURFQyBkb2NzIEkgbmVlZC4gIFBsdXMgSSdtIHJlY2VpdmluZyBvdGhlciBpbmZvIG9uIG90aGVy
IHBvc3NpYmxlIHRlc3Qgc2V0dXBzIHRoYXQgY291bGQgYmUgYmV0dGVyLg0KDQpNeSAxc3QgYW5k
IDJuZCBwb3N0aW5ncyBoYXZlIHRhcmZpbGVzIHRoYXQgY29udGFpbiBhbGwgb2YgdGhlIHRlc3Qg
ZmlsZXMgYW5kIHRlc3QgZGF0YS4NCk90aGVycyBoYXZlIGxvb2tlZCB0aGVtIG92ZXIgYWxyZWFk
eSBoYXZlIHN1Z2dlc3RlZCBzb21lIHRoaW5ncyB0byBsb29rIGF0Lg0KDQpCdXQgdGhlICIgSG93
IGRvIDw+cncgYW5kIDw+cmRfd3IgZGlzayB0ZXN0cyB3b3JrIiAgcG9zdGluZyB3YXNuJ3QgYWJv
dXQgdGhhdC4gIEl0IHdhcyBhYm91dCBnZXR0aW5nIGluZm8gb24gaG93IGZpbyB0ZXN0aW5nIHdv
cmtzIGZvciB0aGUgZGlmZmVyZW50IHRlc3QgbW9kZXMgaXQgc3VwcG9ydHMuICBJIHdhcyBob3Bp
bmcgdG8gZ2FpbiBpbnNpZ2h0IGludG8gaG93IGZpbyBkb2VzIHdoYXQgaXQgZG9lcy4NCg0KdG9t
IGdpYnNvbg0KaHcvc3cgZW5naW5lZXINCmhwZS9hcnViYQ0KDQotLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KRnJvbTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAb3BlbnNvdXJjZS53
ZGMuY29tPiANClNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgMTgsIDIwMjIgMzoyNCBQTQ0KVG86IEdp
YnNvbiwgVGhvbWFzIDx0aG9tYXMuZ2lic29uQGhwZS5jb20+OyBmaW9Admdlci5rZXJuZWwub3Jn
DQpTdWJqZWN0OiBSZTogcmU7IEhvdyBkbyA8PnJ3IGFuZCA8PnJkX3dyIGRpc2sgdGVzdHMgd29y
az8NCg0KT24gMjAyMi8wMS8xOSA2OjEwLCBHaWJzb24sIFRob21hcyB3cm90ZToNCj4gT2ssIHNv
IEkndmUgZ290dGVuIGluZm8sIGZyb20gc2l0c29mZUBnbWFpbC5jb20sIG9uIHRoZSBmaW8gdGVz
dCBkYXRhIGJldHdlZW4NCj4gICAgICAgc2VxcmQsIHNlcXdyLCByYW5kcmQsIHJhbmR3ci4NCj4g
YW5kDQo+ICAgICAgIHNlcXJ3LCBzZXFyZF9zZXF3cg0KPiAgICAgICByYW5kcncsIHJhbmRyZF9y
YW5kd3IsIHJhbmRyZF9zZXF3ci4NCj4gDQo+IFRoYXQgcGVyc29uIHRoYXQgcmV2aWV3ZWQgbXkg
dGVzdCBkYXRhLCBpZCdkIHRoYXQgY3B1IHVzYWdlIHdhcyBub3QgYW4gaXNzdWUuICBTbywgSSdt
IG5vdyBsb29raW5nIGF0IG15IGJ1ZmZlciBjYWNoZSBzaXplIGFuZCB3aGF0IHVubmVlZGVkIHBy
b2Nlc3NlcyB0aGUgc2VydmVyIGlzIHJ1bm5pbmcgdGhhdCBJIGNhbiB0dXJuIG9mZi4gIA0KPiAN
Cj4gSSdtIHRyeWluZyB0byBkZXRlcm1pbmUgd2hhdCB0aGluZ3Mgb24gdGhlIHNlcnZlciB3aWxs
IGFmZmVjdCB0aGUgdGVzdGluZyBiZXlvbmQgd2hhdCBJJ20gY3VycmVudGx5IGFkZHJlc3Npbmcu
ICBJdCB3YXMgYWxzbyBzdWdnZXN0ZWQgdGhhdCBJIGFkZCAiaW9zdGF0IC14emggMSIgdG8gc2Vl
IHdoYXQgZGlzayB1dGlsaXphdGlvbiBpcyBsaWtlLg0KPiANCj4gSSBrbm93IHRoaXMgaXMgYSBi
aWdneSwgZG9lcyBhbnlvbmUga25vdyB3aGVyZSBJIGNhbiBmaW5kIGEgY29weSBvZiBKRURFQyBK
RVNEMjE4Pw0KDQpUaGVzZSBkb2N1bWVudHMgYXJlIGZvciBwdXJjaGFzZSBvciBmcmVlIHRvIGFj
Y2VzcyBmb3IgSkRFQyBtZW1iZXJzLiBFaXRoZXIgcHVyY2hhc2UgaXQgb3IgZ2V0IGFjY2VzcyB0
byBpdCBpZiBIUEUgaXMgYSBKRURFQyBtZW1iZXIgKGxpa2VseSBpdCBpcykuDQoNCj4gDQo+IEJ1
dCBJJ20gc3RpbGwgbGVmdCB3aXRoIGEgYmFzaWMgcXVlc3Rpb24sIGFyZSB0aGVyZSBhbnkga2lu
ZCBvZiBkb2N1bWVudHMgdGhhdCBkZXNjcmliZSBob3cgdGhlIHRlc3RzIG9wZXJhdGUgaW50ZXJu
YWxseT8gIEJ5IHVuZGVyc3RhbmRpbmcgaG93IHRoZSB0ZXN0aW5nIG9wZXJhdGVzIEkgbWlnaHQg
YmUgYWJsZSB0byBpZGVudGlmeSB3aGF0IGNvdWxkIGV4cGxhaW4gdGhlIHJlc3VsdHMgSSdtIGdl
dHRpbmcuDQoNCldoYXQgdGVzdCA/IENhbiB5b3Ugc2hhcmUgdGhlIGZpbyBzY3JpcHQvY29tbWFu
ZCBsaW5lIHlvdSBhcmUgcnVubmluZyBhbmQgd2hhdCB5b3VyIHBlcmZvcm1hbmNlIGlzc3VlcyBh
cmUgPw0KVGhlcmUgYXJlIG1hbnkgd2F5cyB0byBkbyBJT3MgdG8gc3RvcmFnZS4gV2l0aG91dCBk
ZXRhaWxzIG9uIHdoYXQgZXhhY3RseSB5b3UgYXJlIHJ1bm5pbmcsIGl0IGlzIGltcG9zc2libGUg
dG8gY29tbWVudCBvbiBwZXJmb3JtYW5jZS4NCg0KPiANCj4gVG9tIEdpYnNvbg0KPiBody9zdyBl
bmdpbmVlcg0KPiBocGUvYXJ1YmENCj4gDQo+IA0KPiANCj4gDQoNCg0KLS0NCkRhbWllbiBMZSBN
b2FsDQpXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gNCg==
