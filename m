Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B089C4332F
	for <fio@archiver.kernel.org>; Fri,  2 Dec 2022 06:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiLBGYu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 2 Dec 2022 01:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiLBGYc (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Dec 2022 01:24:32 -0500
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A843CBDCF1
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 22:22:23 -0800 (PST)
Received: from pps.filterd (m0209329.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B24LkgB013810;
        Fri, 2 Dec 2022 06:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=Zjnd65qYaami/QcebnF2YN9D0Jv7OaNNP8KFFgADjXA=;
 b=elliJ2aNj5BhDDCMy+N74/eRqnLYd0VhuRlO0tHezOTibCXnYWF9JoZo8g31Ex06rmYe
 re7EkTnfTAwRJrGw4uyTHkX0w/EJjO/uKl3kuAqkeOc52caAiz0+XeWNLWX7vYg6xQpd
 tQuToHj+cZnlW4L15YyDFFTSdbGsT5xfTKY/wyuZBAoAcmOF6nYTFFkV2hcEe0aQLnUM
 4HSHAUOSqq4Wd5q/L7eWLq7hPiz/fi1ZpRQ+8mfj1RkaDB0fDJwiO1vua00TRNgIGOin
 fSwUa95R5SYGODExkbn6GVAnGo44cO+wpHJDRDCEFx75VTr6YS81uLP7nXKKzx8rTA0E Mw== 
Received: from apc01-sg2-obe.outbound.protection.outlook.com (mail-sgaapc01lp2109.outbound.protection.outlook.com [104.47.26.109])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3m39f1pjrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Dec 2022 06:22:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAB0o6K00Sbe6sSCnM7PYotwcne/ZJNDxirE7QmgOlYdPofGHXAHqANzS8TtOQuhAYr77K7YqK52jyqS6f/q7ph6c47f9UsCAwSGrassnboXQmZurMCkjEsLDyIdd20Raxd/NkoBl09OXHsOIYV0t/Y23mqGZMX2tajZbKfvqskqf19+YTUrI4Cq1XvhrAfS2JB+XyKWiRdi2p4RPGBgtSUSn8TL1uTnZ+mCiPJlRiuURmhfB5LQKlrjMAC+gKIRz+VTXll3NqcMCMoFbde6BjJ7b1QHA9ReJehejU58c4G1zSj4qeZ5Xng61ZhNd3RUV7cDXiz5uMXw5QItrn78Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zjnd65qYaami/QcebnF2YN9D0Jv7OaNNP8KFFgADjXA=;
 b=YdwY771uBXjByuU5xa0A0BVDkleeQn/vkkNv+322xqNiTmI2yC9LKyNFl7w4UK1ahPKahlz8gUtyEWxz00vuS7HwAznU5p5bW4WB8HPLbsqZryB5N3uav/+WeQsMtWnZmFRiCx/k2QM7ajAGX4Y4PKW+aqeSV6uX63cBsaGPE7o/yJKvSTw3w3HINOpYgSxcpFphL6GjlI1NpNmSM5qNEZcf9zl3zXW0Xx2qc+Mnqjwvs4DpNJ8zaimidEvVx0eSBgAu8jiz5hd+5csdHLTBzdEw7a8RxWVgVQUWxMRqZzsBlWrWu7tl+S8OUe3T0FbgjJVePLLQN6kGPpkQiwRJvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by TYZPR04MB4383.apcprd04.prod.outlook.com (2603:1096:400:2b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 06:22:15 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e%3]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 06:22:15 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     Vincent Fu <vincentfu@gmail.com>, fio <fio@vger.kernel.org>
CC:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>,
        "Kento.A.Kobayashi@sony.com" <Kento.A.Kobayashi@sony.com>
Subject: RE: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Thread-Topic: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Thread-Index: Adj4yimqLnbaVLwfS9mikvNy15l48gClO0eAAIz+hdABobQwgAB5N+YA
Date:   Fri, 2 Dec 2022 06:22:15 +0000
Message-ID: <HK0PR04MB238808B61BFE4C50E3C1E3C3FD179@HK0PR04MB2388.apcprd04.prod.outlook.com>
References: <HK0PR04MB23884FFF415F7EFCB424CABEFD049@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <7c4b684c-03e8-9f33-3809-443ac7678a07@gmail.com>
 <HK0PR04MB23882A7010C577D1EA34FB57FD0A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <9efdea12-679d-d8f8-b240-c21100adbc10@gmail.com>
In-Reply-To: <9efdea12-679d-d8f8-b240-c21100adbc10@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HK0PR04MB2388:EE_|TYZPR04MB4383:EE_
x-ms-office365-filtering-correlation-id: ae126882-9a4d-4095-a3ae-08dad42d8e4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d7GWuP7oqmnUpOsA/Ustalg3vc9FPxPU/pLTt+N/tXia/hpWhHZ+SGHTJ8tq2q7u9BMtYl2YOJasAhnKHtlZL8QiFq8V2DEJBju+SiAW7O3S5kFEGxfn6AKg65qk4iNER71sS+hI9PfNdaYflrFL6LMmT4KooHZJOix28pv3iqRWflib8hTVGbHjcsecffCMD/k8c5Qtg8gULhzVLV3SbyPnmEejGFqPF0QB9N/4bKrloW/Kg3Gkgp9CiWMTSFLilepk9z/MJLkIX0EaJw0Ug89xSA7G7SwgFTHItmsIlHPx+9T0CFGi2YBrh0N38iknjceayZak5/gJ8XZSoC1G6udTrMnq/GPf5Yi0Qe5DCMtuiIss6Ka+44WoinVS9Zj3252dzR2gDiFojYuooJIlHLwYa3MIUtWzVqoph1wVFJihn0oc+z03ukkn6oJomKQ92WYvIfOsdHagBZ6AQAMvJryFBaDz22j3r07/Df0uqS7TBse/32lVLQE9fxXkQ71o3yf0/ykpdWV0C5Mv0DyxOUkG7w5J8eFGRb9ylUY2T+ek+ttVr8JM2RD1I1jgnTOkYpa/KoF/+xvOD1K7c9Iu4+3P6T7g90Xni4N+Y3oL+sEw3bvF2wRx5+N1NnSxt8/y4G1vVtoVb0cNVMCiFttmibSYrarLhTpew+3vs5ldjFPeyZcvEU/ryqswqG0+YeyWgeBMICioM1z3MI26OOlF4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199015)(83380400001)(2906002)(107886003)(6506007)(33656002)(64756008)(66476007)(66556008)(66446008)(7696005)(76116006)(8676002)(478600001)(66946007)(41300700001)(26005)(53546011)(122000001)(9686003)(71200400001)(82960400001)(4326008)(186003)(52536014)(38100700002)(86362001)(5660300002)(316002)(8936002)(110136005)(55016003)(38070700005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUM3SitkNUF2TUR3MU4xSjVqSGxNNUhxalphUzlqZldwd0V5Z2NMVmJ5cTVv?=
 =?utf-8?B?NEFTaDBSaFREMll1V0plOXowM0hvQk5KQmhTVGx2QThqaUdta3hHY0dpNHA5?=
 =?utf-8?B?RUpvcWs1VXI1aHNNL3FkQitEYm5naDFVQnZXOTNTM2VOenZ2VDNqN21UNC9s?=
 =?utf-8?B?ZFhkRUVOSlFkbHBMOThtREFEY0xac3FSaXVIZzdvSHI2bnhDNmZZWWU4TEQ5?=
 =?utf-8?B?TzhVY0JLLzl2Q3hDM05GZTBqUGx6TXNkcmplaE13MFNQYmpuRHlTb09IWGdz?=
 =?utf-8?B?SmlkM25zNmJnc3RmTUorN1BsOTlEZkhPWWNwcjhhR2JXZE5zTEsvOEhNWVBy?=
 =?utf-8?B?N3l4TE1ieEtaR3VTR3Z0UCtWOVByTWJjMkY0SjVJUUxIQ3Y2d21DMk9MTDli?=
 =?utf-8?B?cUV4UHdBbkxOd1U2Zk54OWNRTERZWXRTWjAwUG1KN3pnNm11bFVyYjJWYzg3?=
 =?utf-8?B?ZHJPUG1XQkp2bG14cmYrV0tvbVg1UHl4K3BDbXVtQkpvbjdRY0M3MGlZeHJw?=
 =?utf-8?B?bEhldnZxcmNLTWI4dGZCNklrQ09aSzFwcGpWS0VpT09RK3hDK29TVEhpcW1t?=
 =?utf-8?B?d1FvM1RxOVk5MExWNmxEOUtuOHN2bGdDak5kWW81bHliZm5aYXUrWVNoMldz?=
 =?utf-8?B?d2I1WEk4N0RHYXFCckJ6SjQxa0dGQWxSWjJ2dURVdzU1L1I4VUhCdXVkdE9Q?=
 =?utf-8?B?d0tEaHlIaXlqQmQxcjVualRNM3JpU2VrN3ZuYktoQVJET3AvMGZ0alFIK3Np?=
 =?utf-8?B?amkzN2NGSXBnQVRWaXVwQlY2NDZ1NmszczdkSDZRUGRZck5SUml4YThYSDlF?=
 =?utf-8?B?N1pXUUExMzJUbFhCTTJtckpMeklCaVN2RHpKLy9wV3dDM2lvZnM3MWc5bzY1?=
 =?utf-8?B?WXNkTzdTcTdkSHZJSWlvakRMRUhQc2c2enM5Z2lkZUx6SXVBWVpLQUV1Q0lD?=
 =?utf-8?B?U0IwZVNzcVVOUEI1cFFYb2tUelFpRVN6cjI0T1ZSNG5FdWlHWllLc1NtdTJI?=
 =?utf-8?B?ejhwSlN2RXg2c0lQaDNJTVM0M0t1T0QwME1GZFl5V3JMTEc5L3hJbnVzUlRE?=
 =?utf-8?B?cytPQXBnMHVISHFzSnkrbjdMb2pQb1pyazhmb1lHb25mQnE0Y0tBUXZmSm5V?=
 =?utf-8?B?bytIcU4yRW9TckEvM1p0UllORTJBSlVPL2tiSDViY2dPd09QVE0vS2pIMXc1?=
 =?utf-8?B?ZmFQVStUS3JabHF4ZExsYUl0ZXN2UllPbDFsKzVtcXFhUUlkdmFjVjdYSEVp?=
 =?utf-8?B?ZzYrbHNieWo1ZFdIV0x1ZjhKQ0IvVWVkak1yVG5KbWl0Zld1cmpMNWhEd2I1?=
 =?utf-8?B?UVhwdE50MGp2eGVYbjNZZUwvV2RPLytMOUV6N2RtM3F5TmFRbDlIbS9kOFA5?=
 =?utf-8?B?NlBWQkJ4c01tM2R0d0NzUnJKdHVZLzBoSDJrZmVJa21rZmNhOHNpTlFaajk0?=
 =?utf-8?B?Q0ZUYTA5aFBnOEE2ejhzY0FsVFhHN0pQVVVZck1zTVo0WTM0OVMzUElvTlc1?=
 =?utf-8?B?c29CUkx3cHArTkpZOENOU2lPOUZlVFRVbEJNRlZnUEpKamFwWVhGd0U2ZkFp?=
 =?utf-8?B?ai83RjNTYjE3d1V5QWIvU1VRWHhSQ1FZTnY2NDVhNHVQT3BYbkh3Smg3ZFVa?=
 =?utf-8?B?eGw0WjVRUGxJVTgrajgvRXlEellHbTluL2ttWVgzY0xZZVFhQ0hrblBzdEpa?=
 =?utf-8?B?QUNQMFdCZ1l6Nm0xZTlLcU5UanV3WlVsUXozNDBHSytYaTl0dDN1TU5XdE1N?=
 =?utf-8?B?TFU4cDlzdkxidEpHbDhjcVlNM2IzdUhqRE5melpJOXRyVVlGazZCTWlwWW9s?=
 =?utf-8?B?N3Flb29md0Z1bTlPRC94UUhYQklsMzQ2ZVN0djVCQyszd0xoRUE4RUFoVkgy?=
 =?utf-8?B?MzVXTTBvVEthMlE3MXhkU0plSFV1L1BWck96WUt2WisrSjVkcjNTMFdST25D?=
 =?utf-8?B?QnFlWS80ZDhCbEUwUXpqemhOWWlZcUpPNU1WRHVjSXk3SHpQNmg5amFKY3RH?=
 =?utf-8?B?b0YxRmVFcUFyRGovR1lkVThwdy9od0ZRd3VCR1pkWHZmeUNCRFlsUm1icElT?=
 =?utf-8?B?clUyT1ZsN3c1S2F0RzBUZHV4Sk1FcDFDcVA0UURnT0xkeUdCRW4zc0IxVDg0?=
 =?utf-8?Q?My81CCYn0uJFJM8QqNjNpWuyX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qfmhId3c5ydGW8gERTMX6A56y2bmDVuuA7jrejFg+fuzksoBcZxUOEai/l+9DUBBL2FF/uR7nn3R/ptR+JKSwB4H7f0YOGH4sKeKV4GPzAcRB5Y6jCmkeRTkO8sp/eYes33d2dP/u7Y6ey258TzoQ43e8kRoUL/i1SMc/4lGRfpxGpZGQyUOXQvVx1GOeRH+D7a/eI08gxEFQWctTc/QWaflwJMnmcEGqNfEkhX9HMg8e2ggthawNgyUoR7cF0EqaynM4e8eZb2cOoyOPOpNPx7rr6NltYa5GrkdwhsyciaWI62c8I3ZqqZjQzcWf2KwnCuMJMgeeLQ6KcRd3FmjRyvvN1cqHFeOR3ZLzFgpFqtx/gYNNElCnVxioBLXqkDk4/8mau7+dk+Opu56+Vi6c7sI4WI1xe+xtxajL/MQpHf7VzuN73fH2qupwdAmwv/6XpecE8nGZdGGT0l68HSairrkEX1OCI/vgqm/ti3aQ4w82eraoru91W38Dji4Zwt8NPtJQw8OPwr5gDxrn6E8PMjkQWfHflhky+7RNeJQd8UisbA+CXxt0ajxx8EK7vzvf6Piamr/QOJVUuPSSafxNLAZc3Gd6ItRu022uSQHmTah3U15h1z06NH3DERKCQd0CaEodNxL9xyalt6WZ5wdWIvMkdokxp/SL1TnXExespfM37Nyot9r7illC3qomp0TxOhl8yuEuYrl7FERwg3ZVKx3cjksTQMzc2cDE1WVwFFai3PwWNT6BRrfx+IeCk/6IrRiYE8QFxpCOOXu5IeVEhYBQmN6fOE4j5BSnILHiqE9zwNFO8E7YFVwd6M4JUFA
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae126882-9a4d-4095-a3ae-08dad42d8e4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 06:22:15.1594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I6jkPL6RCBiX+dxi4DdsymoMLZWJVU8CxKPkcDc0EHMbklvs4rwzN6/qXyd9fxEr+5krcnBYUPY+mHqWSbgGJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB4383
X-Proofpoint-ORIG-GUID: RaS1wi0m-7SbcFUCNMWclX1433KnFXch
X-Proofpoint-GUID: RaS1wi0m-7SbcFUCNMWclX1433KnFXch
X-Sony-Outbound-GUID: RaS1wi0m-7SbcFUCNMWclX1433KnFXch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_02,2022-12-01_01,2022-06-22_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SGksIFZpbmNlbnQNCg0KPiBJIHRoaW5rIHRoZSBiZXR0ZXIgc29sdXRpb24gaXMgdG8gYXVnbWVu
dCB0aGUgZG9jdW1lbnRhdGlvbiB3aXRoIGEgDQo+IGRldGFpbGVkIGRpc2N1c3Npb24gb2YgdGhl
IGZpbGUgb3BlcmF0aW9uIGlvZW5naW5lcyBiZWNhdXNlIHRoZXkgd29yayBzbyANCj4gZGlmZmVy
ZW50bHkgZnJvbSBvdGhlciBmaW8gaW9lbmdpbmVzLg0KDQo+IEJlY2F1c2Ugb2YgaG93IHVudXN1
YWwgdGhlc2UgaW9lbmdpbmVzIGFyZSwgdGhlcmUgYXJlIG1hbnkgd2F5cyB0aGUgDQo+IGlvZW5n
aW5lcyBjYW4gYmUgbWlzdXNlZCBhbmQgdGhlaXIgcmVzdWx0cyBtaXNpbnRlcnByZXRlZC4gTWFr
aW5nIGEgDQo+IGNoYW5nZSBsaWtlIHRoaXMgcmVkdWNlcyB0aGUgcG9zc2libGUgY29uZnVzaW9u
IGJ5IG9ubHkgYSBzbWFsbCBhbW91bnQuIA0KPiBIYXZpbmcgYSBkZXRhaWxlZCBndWlkZSB0byB0
aGVzZSBpb2VuZ2luZXMgaW4gdGhlIGRvY3VtZW50YXRpb24gd2lsbCANCj4gbW9yZSBjb21wcmVo
ZW5zaXZlbHkgcmVkdWNlIGNvbmZ1c2lvbiBhbmQgbWlzdXNlIG9mIHRoZXNlIGlvZW5naW5lcy4N
Cg0KSSBhZ3JlZSB3aXRoIHlvdS4gRmlsZSBvcGVyYXRpb24gZW5naW5lcyBhcmUgZGlmZmVyZW50
IGZyb20gSU8gZW5naW5lcy4gTWFraW5nIGRldGFpbGVkIGV4cGxhbmF0aW9uIGluIGRvY3VtZW50
IGlzIG5lY2Vzc2FyeS4NCk1lYW53aGlsZSwgaXQgaXMgc3RpbGwgcG9zc2libGUgdG8gbWFrZSBy
dW50aW1lIGpvYiBkZWZpbml0aW9uIGFuZCBsb2cgb3V0cHV0IG1vcmUgZnJpZW5kbHkgdG8gdXNl
ciB3aXRoIG9ubHkgc21hbGwgbW9kaWZpY2F0aW9uIHRvIGNvZGUuIFRoaXMgcGF0Y2ggY29ycmVj
dHMgJ3J3JyBmaWVsZCBpbiBqb2IgZmlsZSBhbmQgbG9nLCBuZXh0IEkgcGxhbiB0byBjb3JyZWN0
IElPUFMsIEJXIGZpZWxkcyBpbiBsb2cuIFdpdGggc2V2ZXJhbCBzdGVwcyBvZiAibm90LWJpZyIg
bW9kaWZpY2F0aW9uIGdyYWR1YWxseSwgaXQgaXMgc2FmZSB0byBtYWtlIEZJTyBmaXQgZm9yIGZp
bGUgb3BlcmF0aW9uIG1lYXN1cmVtZW50LiBJIGhhdmUgc2VudCB0aGUgUGF0Y2ggVjIgd2hpY2gg
aW5jbHVkZXMgcnVudGltZSBtb2RpZmljYXRpb24gYW5kIGRvYyB1cGRhdGUuDQoNCkluIG91ciBw
cmFjdGljZSwgZmlsZSBvcGVyYXRpb24gcGVyZm9ybWFuY2UgaXMgb2Z0ZW4gbWVhc3VyZWQuIEl0
IGlzIGFzIHNhbWUgaW1wb3J0YW5jZSBhcyBJTyBwZXJmb3JtYW5jZS4gSXQgd2lsbCBiZSBlZmZp
Y2llbnQgaWYgd2UgY2FuIHV0aWxpemUgRklPJ3MgcG93ZXJmdWwgZnJhbWV3b3JrIGFuZCB2YXJp
b3VzIHN0YXRpc3RpY3MgZm9yIGZpbGUgb3BlcmF0aW9uIG1lYXN1cmVtZW50Lg0KDQpCZXN0IFJl
Z2FyZHMNCkZyaWVuZHkNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFZpbmNl
bnQgRnUgPHZpbmNlbnRmdUBnbWFpbC5jb20+IA0KU2VudDogV2VkbmVzZGF5LCBOb3ZlbWJlciAz
MCwgMjAyMiAxOjQyIEFNDQpUbzogU3UsIEZyaWVuZHkgPEZyaWVuZHkuU3VAc29ueS5jb20+OyBm
aW8gPGZpb0B2Z2VyLmtlcm5lbC5vcmc+DQpDYzogQW95YW1hLCBXYXRhcnUgKFNHQykgPFdhdGFy
dS5Bb3lhbWFAc29ueS5jb20+OyBLb2JheWFzaGksIEtlbnRvIChTR0MpIDxLZW50by5BLktvYmF5
YXNoaUBzb255LmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggdjFdIGZpbzogQXBwZW5kICJmaWxl
Y3JlYXRlL2ZpbGVzdGF0L2ZpbGVkZWxldGUiIHRvICdyZWFkd3JpdGU9Jw0KDQpPbiAxMS8yMS8y
MiAwNTozNiwgRnJpZW5keS5TdUBzb255LmNvbSB3cm90ZToNCj4+IEkgdGhpbmsgaGF2aW5nIHRo
aXMgb3B0aW9uIHdpbGwgYmUgY29uZnVzaW5nIGFuZCBsZWFkIHRvIHVzZXJzIHRyeWluZyB0bw0K
Pj4gcnVuIGEgam9iIHdpdGggLS1pb2VuZ2luZT1wc3luYyAtLXJ3PWZpbGVjcmVhdGUuDQo+IA0K
Pj4gSG93ZXZlciwgSSB1bmRlcnN0YW5kIHRoZSBjb25mdXNpb24gdGhhdCBhcmlzZXMgd2hlbiB0
aGUgZmlsZSBvcGVyYXRpb24NCj4+IGlvZW5naW5lcyBhcmUgdXNlZC4gTWlnaHQgdGhlcmUgYmUg
c29tZSBvdGhlciB3YXkgdG8gaGVscD8gUGVyaGFwcyB0aGUNCj4+IGlvZW5naW5lIGNvdWxkIGVt
aXQgc29tZSBzb3J0IG9mIG1lc3NhZ2U/IE9yIHRoZSBkb2N1bWVudGF0aW9uIGZvciB0aGUNCj4+
IGZpbGUgb3BlcmF0aW9uIGlvZW5naW5lcyBjb3VsZCBiZSBlbmhhbmNlZD8NCj4gDQo+IEkgY3Jl
YXRlZCB0aGlzIHBhdGNoIGJlY2F1c2Ugc29tZWJvZHkgc2VudCBtZSBlbWFpbCB0byBhc2sgd2h5
IHJ3IHN0cmluZyBzaG93cyAncmVhZCcgd2hlbiBoZSBtZWFzdXJlZCBieSBmaWxlY3JlYXRlIGVu
Z2luZS4gQW5kIG1vcmUsIHVzZXJzIGZlbHQgc3RyYW5nZSB3aGF0IGRvZXMgSU9QUy9CVyBmb3Ig
ZmlsZSBvcGVyYXRpb24gbWVhbj8NCj4gSSB0aGluayB3ZSBjYW4gZG8gb3B0aW9uIGNoZWNrIGF0
IGJlZ2lubmluZy4gJy0taW9lbmdpbmU9ZmlsZWNyZWF0ZScgYW5kICctLXJ3PWZpbGVjcmVhdGUn
IG11c3QgYmUgcGFpcmVkLiBJZiBub3QgcGFpcmVkLCBlbWl0IGVycm9yIG1lc3NhZ2UgYW5kIGV4
aXQuIEhvdyBkbyB5b3UgdGhpbms/DQo+IA0KPiBUaG91Z2ggRklPIGlzIGRlc2lnbmVkIGZvciBJ
TyBtZWFzdXJlbWVudCBvcmlnaW5hbGx5LCBmaWxlIG9wZXJhdGlvbiBwZXJmb3JtYW5jZSBpcyBh
bHNvIHJlZ3VsYXJseSBldmFsdWF0ZWQgZm9yIGZpbGUgc3lzdGVtLiBJdCBpcyBoZWxwZnVsIGlm
IGV4cGFuZCBGSU8gdG8gYWRhcHQgdG8gZmlsZSBvcGVyYXRpb24gYmVuY2htYXJrLg0KPiANCj4g
RnJpZW5keQ0KPiANCg0KSSB0aGluayB0aGUgYmV0dGVyIHNvbHV0aW9uIGlzIHRvIGF1Z21lbnQg
dGhlIGRvY3VtZW50YXRpb24gd2l0aCBhIA0KZGV0YWlsZWQgZGlzY3Vzc2lvbiBvZiB0aGUgZmls
ZSBvcGVyYXRpb24gaW9lbmdpbmVzIGJlY2F1c2UgdGhleSB3b3JrIHNvIA0KZGlmZmVyZW50bHkg
ZnJvbSBvdGhlciBmaW8gaW9lbmdpbmVzLg0KDQpCZWNhdXNlIG9mIGhvdyB1bnVzdWFsIHRoZXNl
IGlvZW5naW5lcyBhcmUsIHRoZXJlIGFyZSBtYW55IHdheXMgdGhlIA0KaW9lbmdpbmVzIGNhbiBi
ZSBtaXN1c2VkIGFuZCB0aGVpciByZXN1bHRzIG1pc2ludGVycHJldGVkLiBNYWtpbmcgYSANCmNo
YW5nZSBsaWtlIHRoaXMgcmVkdWNlcyB0aGUgcG9zc2libGUgY29uZnVzaW9uIGJ5IG9ubHkgYSBz
bWFsbCBhbW91bnQuIA0KSGF2aW5nIGEgZGV0YWlsZWQgZ3VpZGUgdG8gdGhlc2UgaW9lbmdpbmVz
IGluIHRoZSBkb2N1bWVudGF0aW9uIHdpbGwgDQptb3JlIGNvbXByZWhlbnNpdmVseSByZWR1Y2Ug
Y29uZnVzaW9uIGFuZCBtaXN1c2Ugb2YgdGhlc2UgaW9lbmdpbmVzLg0KDQpWaW5jZW50DQoNCg0K
