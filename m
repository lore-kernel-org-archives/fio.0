Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0BDC433EF
	for <fio@archiver.kernel.org>; Fri, 24 Dec 2021 12:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhLXMRD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 24 Dec 2021 07:17:03 -0500
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:13458 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232072AbhLXMRD (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 24 Dec 2021 07:17:03 -0500
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO7Vsg6014835;
        Fri, 24 Dec 2021 12:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=pps0720;
 bh=p16YZ2qoS06x5y6tl+MjKeUTF/WuSAp8zy9zrOP+vWw=;
 b=GLQw0IBKm2I/Z1wYP6xoFCBG1HEr9YxH/gI1NkgnqUofkJiPa+zazM+h/D/jpnZVF44B
 L6zzYGAQS5LiyA1jQ9TFckBY4VVo8+BH5giifsVQbsj6uOdB6LU7IYo0xaVLUoXutfWR
 XTVZGHeItDdYvb9uMenwd53vrQq6vLjSRGLliW5DgbcQoHomK89T00BE+V/4IABOMWKj
 GCaiHSSbzhPN5P2Vr6meIed8bBOSvLJBCbSn1arXqwTDxSh2OZXsVwmwpaGFLh73s/+w
 hsTQndoWcWgJNZi4HP53prgk/8LhMUlDmstYKP+U7UJ9AgIGRtUlVkyLseqPtJTHmcu/ hA== 
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3d4swv84sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Dec 2021 12:16:58 +0000
Received: from G4W9121.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net [16.210.21.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2353.austin.hpe.com (Postfix) with ESMTPS id 3F55C84;
        Fri, 24 Dec 2021 12:16:57 +0000 (UTC)
Received: from G9W8453.americas.hpqcorp.net (2002:10d8:a0d3::10d8:a0d3) by
 G4W9121.americas.hpqcorp.net (2002:10d2:1510::10d2:1510) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 24 Dec 2021 12:16:56 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (15.241.52.13) by
 G9W8453.americas.hpqcorp.net (16.216.160.211) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23 via Frontend Transport; Fri, 24 Dec 2021 12:16:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fYdwuMch1aIhnoKkB/FMZaiXasgkrRtF8AiagX6sTVu8B5/q6mlfxBu+lJcwkf9zWL6/wSLRg4iupNYk45jpSwWt5c+oB5rzrg3o8v/IKE7JJOwn4M78ruNK4GhTeoF7nxrqMV8Wqe6RPzwgSgdN03knxrN9V5ePNdrbVmzJnXB4oX3BqXN7WORryMU9gBB9Mrlhifd7xaz6vZyZa6WWFi4vS8r5MMg/LLp30lu7lTYiqr/v7npMstlNWwOuB5gXO8u728OEJG9qC0fe+mDrHyDvNyNloZXsyXJ8dFc0Fn1HEFF5V7/ahsi7AnReGghTwl2C32aG+i2tLxdtGv7K7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p16YZ2qoS06x5y6tl+MjKeUTF/WuSAp8zy9zrOP+vWw=;
 b=LrQsPTBiITWcuZ/eZUif20MHAzw9lT6hyPredJHZGViioJcMVNxzSABfP3GxQvlydvJuNB5HFRGQxzzP7SVlydWtswmEzYI9vvKF7UodqFOUdacKzdSkxfn2H9Sjtf7aRjfbOlA3nxoSYftDXxpZ0ehxnPBR1y1EhA75EJZCpc9qlJVoaIFdLfj9mHyhwqOFY2L+tzg2DvoEWdH2wkcBxHmAhU3t8VnW80Di+VZ48kIwJTE51rsUoOF9ez0DeiJGqv6Lw3FYskO4pmWBPhpxeDPKahbtafGIRoDEjutrM1TujgDYCtY1wE5G6y7oWRPEK43FyHSkdLgvAIbyTjuAQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::13)
 by PH0PR84MB1764.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:162::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 24 Dec
 2021 12:16:55 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10]) by PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10%4]) with mapi id 15.20.4801.020; Fri, 24 Dec 2021
 12:16:55 +0000
From:   "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
Thread-Topic: [PATCH 0/1] t10-pi bio split fix
Thread-Index: AQHX9ae9F1LvItF/X0quij8FY4R836w7kj8egAY1AgA=
Date:   Fri, 24 Dec 2021 12:16:55 +0000
Message-ID: <82F812AE-BEFA-4F57-A134-C1EED7F1928E@hpe.com>
References: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
 <yq1wnjzi6oc.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1wnjzi6oc.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ca7ee0e-c237-4bee-93c4-08d9c6d746c6
x-ms-traffictypediagnostic: PH0PR84MB1764:EE_
x-microsoft-antispam-prvs: <PH0PR84MB176468F7D44B0F628756E0DBF77F9@PH0PR84MB1764.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g7edBJ0GKuv5oN2WKYi63SUNKVTK0zeGUFqbmeYLnr9hSXoZAjw7bx+LPf4pRWEDw/Ag/Wakc9rkNPJWW0Ap8Y3Ic8UtYm8M04LQRBjFq0TAUgubutfJZo0CqqKwDFOfDbULh0CBw79+zg3GCzrAdkXmZs4hMjQU6UPTqg9uNMW0efpx5YvbLCLWPcCtQef515XEg2wD+dpshbhWhxgnF1XkmzmYyXUWLB0GWQ7ls1UPpp5k6gFelPBH9dXb604OrcBpNO+Z++8+0u5Eh3avYfyOvskTQA2u7nAKR+KN6oqvVAY8PYbL1YZlY2FePKDhlLWMpICVA2fkZeTT760DSb7HssSTGcBboyAjy5HMOJAA4EpQGQhVbHp50MgjdpQ5jjp8ci4aDAp7OEqy7Ng2z3ef0aMg/mQfpshwM62YsoWshbMPMerVuzEVbmDan3Rjb3XNvLFM7IvnsxZahZodyE6Q6aZtaY5xDbrXP6TDCD2gHd1aLWdgFA9RkPTX7TZJF0sI1PJcGtcJbtdCkKtqnFeK6b2u7cNlwy0L8jBHlbVU7L222GudDjIqtYor0dNDq0fRiw4y2R3BiUynQ0ZvCo6hhFPJT+V9a5sEfrkJr7Xc9krr2Ew5d1p+c7DRsz4Xe8qQida6PYX+jE20VyTgZfH+WQwzalpG6meANJfSLNHUxZ5+FArzrYAe7LfNFxP+gCKlDyuOHLrWL1ywWpZbG7J1VAlBW/78dZ6bQIlq7SE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(316002)(71200400001)(54906003)(8936002)(86362001)(82960400001)(6486002)(38070700005)(38100700002)(2906002)(2616005)(36756003)(6512007)(5660300002)(4326008)(122000001)(508600001)(6916009)(66946007)(66446008)(8676002)(33656002)(26005)(66556008)(64756008)(6506007)(76116006)(66476007)(186003)(91956017)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVp5L2FOWUNPK2l2bE13VndsNkx1cGxQL25PVlJvMmxXVE9DZVdPM3B4RDJE?=
 =?utf-8?B?a3R3S3BCU1FaS2JvN2hrTnhxaU9lNWhIL2tIRXgyUUo0SzR1b0xaQ214azls?=
 =?utf-8?B?V29wUWZPcXhuNHJpZFFjUXpHaTh3SzcwUlJQZy8weDNzZ0VGN0JmNnBadTFj?=
 =?utf-8?B?bHc3NVMxTVBqRW11ZiszYkxYZVJCN3l0ZTBLV09DK2hjZGh6Zzk1MlMxc05O?=
 =?utf-8?B?NFg1SjY0NXd1TWdIOUxjNTZVNnFOYVR5elR3QnJwZ1gxQktJTjN3MDlkNW90?=
 =?utf-8?B?K0ZKNmxydlFPcVU3azNHeTVWOW1YUGdlWGlGYWhTNFRwRWNTYmtzQU93ZmZN?=
 =?utf-8?B?cnExL0ZlNU81dCtDZVVSR0l2WFo4OGxjQXFJcGtQNWIyN0h0NTdrelhGMUM5?=
 =?utf-8?B?TmR1cEg4U2g1S1NHNzdraDRaT1dTN0ZEU0FleTBBb0pmaDRTWGtTNGRoNTMv?=
 =?utf-8?B?Wm9LR3BxN2IyRjRTY21lcmM1dTZNZTBjcWU0SkQzdVUyaW5WTVhVWU9xNDhR?=
 =?utf-8?B?d1FLMUtPOVlXQmFHY3pDc2F2emFxV3owUlJGS1BaamtwUXhhMkU5dGZUYTFj?=
 =?utf-8?B?M3RFdlBTaUpRMk9UY0ZKc3VQaWRJbG9ZUnR0ZmxqaVdpOFYrTmZYUm9CNW51?=
 =?utf-8?B?RzE1d0JCd2VjWUpCRHkrSXFYQTN4amJCWWlacXRXcFVqcWpXbC9sQUxGVkRU?=
 =?utf-8?B?cFlzazFtQWdtNFB2Mlo0VlQwRzBuTC84d0MvRnRsK1FnYVg3V2RuUEJ6aGpt?=
 =?utf-8?B?V2ozQmpXREhJeTgwYkJBSWNHbGZkVXA3TFBwSDh0YnMzVmRBaFJhVmtLaVZO?=
 =?utf-8?B?aVJLZWdvdDVreFFOQ3QzZ0x3d09MdWg1d1NpSVJpU0U2QjFLckdlNFdWZzln?=
 =?utf-8?B?Y1JNL2JSRXFvcS9xNkpWT0k3eE5nTXBBS2s3L285aEVVOW5GaFN4RDd3amlp?=
 =?utf-8?B?T2ZLUDJLVkM2NmxSZWhQS1NsMjJUZVVuSFkrMFh3YUdSblk3SVhmZVRHUFdS?=
 =?utf-8?B?TlM1NmF5MXBlL3o5QXVlRDhyUXdpeDVnb1Y5ZzlSTGJObFhJYlNFN2ZwV1Vk?=
 =?utf-8?B?VzJUVEN1eUl0VzZKSk5NSXR1WTBxc0hoV3VhWElUSkpsYjZaSnpsMW1WeUpo?=
 =?utf-8?B?SkZKUFhzUXZ0L2V6TkFhYlB6Ym1GdXlEclhzS2cwVEhzdGZxNElqQkJMRit5?=
 =?utf-8?B?MEtmZmhCeVQyOEdaTVk4MERWNkhlOUU4ZzJoVXoyYTJuMmlUOVFiRUorRGYr?=
 =?utf-8?B?Z0NnS3N2N2QwU1hKT2xwbzlPTWwyTFB4aWx5VzBscm1xWUNIMjV5MGN3NUN1?=
 =?utf-8?B?WmF2dWpuNE4rUDNieTFJcFQxU1B2UkpMa3JtaW0yOVhXNFQ5ZS9tYmhYb1BY?=
 =?utf-8?B?ZitKOFNqY01pSlZxdCtFWGN5eGk0MFo4cTRxR1d5RjNFNnlRUjE4bXhiWXJj?=
 =?utf-8?B?aS9GUW5BckhGZGpDUHcwY2I4Q1B6TXl5ejNPMy9ORXVjYXNBWnZEdGlYVzFK?=
 =?utf-8?B?Ym5rSlRDMTdYV1prck1WWmZ6bWJDNHVRUkg1Q2hrck91aEgxUnlLNzFybUJS?=
 =?utf-8?B?VWoxa3dXYmI3b2FIRkhQRGREeXpMUUc3V1ByTUhmRlJQZFFDaEZudTVua1Zw?=
 =?utf-8?B?SGs0Y2pzNXBveTIxR0xyZHMwK0hGSndSdVhBSENwQjFaa2I3bXp4S3g4Q3Jh?=
 =?utf-8?B?ZU5kL29ia3lOcDZyVm9UWlBVbGdCbzZYZUljWDlvS2t2KzlmMElGcHZ4Q3pP?=
 =?utf-8?B?RytvRWFHdXpLeXBmTUhFMFNJL0UzQXMwdUl1cWM4YzJSbFJKb2Y0dktiVGZN?=
 =?utf-8?B?VUNjSS94TFBBcmpycTdiNmpQZjNBUjlBcS9Kd0FXZzFSQ0VYOUtOM09GU2NI?=
 =?utf-8?B?WTEwZlNPbXpYVllnZ3gvSVBJVmJtcCsrMW0xUm1WaC9jakJpUzFsVi96VWRa?=
 =?utf-8?B?dG1jZHpuZmRFbC9qRFNtU3NUSjE5U29IWUVaMjlPdVVweldJODRWeVM2czIy?=
 =?utf-8?B?UlErMVI5dkp4NGRjRWU1OFNXK0RzamoxYWU2eVIwOVVPcVVIVHA2dGh2Unhl?=
 =?utf-8?B?MXNlZjVlRFBjby9oZG0yZEZETGNxQXVJclptM3hZc3BzVlhZS0l1ekV6Z2di?=
 =?utf-8?B?bzlpQ0lFOEJZckNRTndwVHZoV1JjbG9MVjAvRUhvdkppY2VCVEVIamU2Um9D?=
 =?utf-8?Q?qV2R8kXiUF4ssMO2iVEbo/c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD7B15458967A540B10ABC0C7FB862EE@NAMPRD84.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca7ee0e-c237-4bee-93c4-08d9c6d746c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2021 12:16:55.6073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P6Oq/cHZd43Abqaj9rsEUpo1Ib/av1m3nUUeXr/gPCHahJ8ARVu2eE5ls49BFTXexBqAaNwYPOy9yWWolj84qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1764
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: V4UxSWBDLgIf53Iz68NKDj6PnmSJ4kxv
X-Proofpoint-GUID: V4UxSWBDLgIf53Iz68NKDj6PnmSJ4kxv
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_04,2021-12-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 mlxlogscore=820 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112240060
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

TWFydGluLA0KDQpTb3JyeSBhYm91dCBkZWxheS4NCg0KSSBkb24ndCBhZ3JlZSB3aXRoIHlvdSBh
Ym91dCBUMTAgUEkgcmVmZXJlbmNlIHRhZyBpbiBjdXJyZW50IGNvZGUuDQp0MTBfcGlfZ2VuZXJh
dGUgd29ya3Mgd2l0aCB2aXJ0dWFsIGJsb2NrIG51bWJlcnMgYW5kIHZpcnR1YWwgcmVmZXJlbmNl
IHRhZ3MuDQpWaXJ0dWFsIHRhZyBtYXBwZWQgaW50byByZWFsIHRhZyBsYXRlciBpbiB0aGUgDQpz
dGF0aWMgdm9pZCB0MTBfcGlfdHlwZTFfcHJlcGFyZShzdHJ1Y3QgcmVxdWVzdCAqcnEpDQouLi4N
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGJlMzJfdG9fY3B1KHBpLT5yZWZf
dGFnKSA9PSB2aXJ0KQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBp
LT5yZWZfdGFnID0gY3B1X3RvX2JlMzIocmVmX3RhZyk7DQoNCi4uLg0KU28sIHdlIG5lZWQganVz
dCBhIHBhaXIgYmV0d2VlbiB0aGVzZSBmdW5jdGlvbnMgdG8gaGF2ZSBhIGdvb2QgbWFwcGluZyBh
bmQgZ29vZCByZWFsIHJlZmVyZW5jZSB0YWcgDQpPbmNlIHQxMF9waV9nZW5lcmF0ZSBoYXZlIHNo
aWZ0IGEgInZpcnR1YWwiIHJlZiB0YWcgZm9yIDQgaXQgbWFrZSBhIGJpb19pbnRlZ3JpdHlfYWR2
YW5jZSB0byBiZSBoYXBweS4NCkFuZCB0MTBfcGlfdHlwZTFfcHJlcGFyZSBhbHNvIGhhcHB5IGJ1
dCBpdCBuZWVkIHRvIGJlIHNoaWZ0IHdpdGggNCBhcyBzaW1pbGFyIHRvIHRoZSBnZW5lcmF0ZSBm
dW5jdGlvbi4NCg0KVGhpcyBwYXRjaCB0ZXN0ZWQgd2l0aCBzb2Z0d2FyZSByYWlkIChyYWlkIDEg
LyByYWlkIDYpIG92ZXIgb3ZlciBOTVZlIGRldmljZXMgd2l0aCA0ayBibG9jayBzaXplLg0KSW4g
bHVzdHJlIGNhc2UgaXQgY2F1c2VkIGEgYmlvIGludGVncml0eSBwcmVwYXJlIGNhbGxlZCBiZWZv
cmUgYmlvX3N1Ym1pdCBzbyBpbnRlZ3JpdHkgd2lsbCBiZSBzcGxpdHMgYmVmb3JlIHNlbmRzIHRv
IHRoZSBudm1lIGRldmljZXMuDQpXaXRob3V0IHBhdGNoIGl0IGNhdXNlZCBhbiBUMTAgd3JpdGUg
ZXJyb3JzIGZvciBlYWNoIHdyaXRlIG92ZXIgNGssIHdpdGggcGF0Y2ggLSBubyBlcnJvcnMuDQoN
CkFsZXgNCg0K77u/T24gMjAvMTIvMjAyMSwgMTk6MjksICJNYXJ0aW4gSy4gUGV0ZXJzZW4iIDxt
YXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT4gd3JvdGU6DQoNCg0KICAgIEFsZXhleSwNCg0KICAg
ID4gdDEwX3BpX2dlbmVyYXRlIC8gdDEwX3BpX3R5cGUxX3ByZXBhcmUgaGF2ZSBqdXN0IGEgaW5j
cmVtZW50IGJ5IOKAnDHigJ0gZm9yIA0KICAgID4gdGhlIGludGVncml0eSBpbnRlcm5hbCB3aGlj
aCBpcyA0ayBpbiBteSBjYXNlLA0KICAgID4gc28gYW55IGJpb19pbnRlZ3JpdHlfYWR2YW5jZSBj
YWxsIHdpbGwgYmUgbW92ZSBhbiBpdGVyYXRvciBvdXRzaWRlIG9mDQogICAgPiBnZW5lcmF0ZWQg
c2VxdWVuY2UgYW5kIHQxMF9waV90eXBlMV9wcmVwYXJlIGNhbuKAmXQgYmUgZm91bmQgYSBnb29k
IHZpcnR1YWwNCiAgICA+IHNlY3RvciBmb3IgdGhlIG1hcHBpbmcuDQogICAgPiBDaGFuZ2luZyBh
biBpbmNyZW1lbnQgYnkg4oCcMeKAnSB0byBiZSByZWxhdGVkIHRvIHRoZSByZWFsIGludGVncml0
eSBzaXplIA0KICAgID4gc29sdmUgYSBwcm9ibGVtIGNvbXBsZXRlbHkuDQoNCiAgICBCeSBkZWZp
bml0aW9uIHRoZSBUMTAgUEkgcmVmZXJlbmNlIHRhZyBpcyBpbmNyZW1lbnRlZCBieSBvbmUgcGVy
DQogICAgaW50ZXJ2YWwgKHR5cGljYWxseSB0aGUgbG9naWNhbCBibG9jayBzaXplKS4gSWYgeW91
IGltcGxlbWVudCBpdCBieSBhDQogICAgZGlmZmVyZW50IHZhbHVlIHRoYW4gb25lIHRoZW4gaXQg
aXMgbm8gbG9uZ2VyIHZhbGlkIHByb3RlY3Rpb24NCiAgICBpbmZvcm1hdGlvbi4NCg0KICAgIFNl
ZW1zIGxpa2UgdGhlIHNwbGl0dGluZyBsb2dpYyBpcyBicm9rZW4gc29tZWhvdyBhbHRob3VnaCBJ
IGhhdmVuJ3Qgc2Vlbg0KICAgIGFueSBmYWlsdXJlcyB3aXRoIDRLIG9uIFNDU0kuIFdoYXQgZG9l
cyB5b3VyIHN0b3JhZ2Ugc3RhY2sgbG9vayBsaWtlPw0KDQogICAgLS0gDQogICAgTWFydGluIEsu
IFBldGVyc2VuCU9yYWNsZSBMaW51eCBFbmdpbmVlcmluZw0KDQo=
