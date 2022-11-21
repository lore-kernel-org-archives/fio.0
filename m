Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E018C433FE
	for <fio@archiver.kernel.org>; Mon, 21 Nov 2022 10:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKUKgj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Nov 2022 05:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiKUKgY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Nov 2022 05:36:24 -0500
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B7BB1B9E
        for <fio@vger.kernel.org>; Mon, 21 Nov 2022 02:36:23 -0800 (PST)
Received: from pps.filterd (m0209324.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AL8bFR2031549;
        Mon, 21 Nov 2022 10:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=IBv09+wHiBWsyqnh3cBLoXYqvmu11IDu5rqdQR0b3wI=;
 b=h0CY9XPZyg2hn0mRhnRcByEbWjgbL7Y5u42QxQOMoyLaI1e6MQILYGhYYclCjzPSx6ax
 s8WOQBNjnAKFmd1dxtgwiSKoI8eWVB0NEtc36GnFOeevH9D2oHStSngiUg6rsJ1k8uOL
 vNA3PWdcAhQ1E24cPqQ+Ef3gHZvpk21+FjtOl/jjj4o6yH7CZ618FbuCsVoPqYm7AHXV
 qKYHE5ORb98q5Ucso5Jgr6VT6PcMnJYxgaiHsolmVcj2OjMGHcJ0kcFE5IQvqux6fIVj
 MF8hQXd+atlUqPab9GMBg5BNGCoIwhlzYjEX4D9NwcDYmjAnkCI5ZzgRGu+4Aj4qY591 Gw== 
Received: from apc01-tyz-obe.outbound.protection.outlook.com (mail-tyzapc01lp2042.outbound.protection.outlook.com [104.47.110.42])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3kxrcu9mdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 10:36:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3Ey3b2ewosQaH27zWdVn7GuBvd3BwVnl4fbJOTeAI+5FVGH3xJ/CMyXgtsl/P4iKPTuX58avkAFFnC714zAtmNtwetklP6CcZdyvspxuKXT7PLUrBrdxyXtSuk7xcHpBwu+F12ai3DTWHT4girsLJ0QClEDcUBonh/eKmCjpfjQyl8cdUr2XiLw93eMUDLAOJoVB018vAvfZDBDMTkVwYdXUSDyS7xb1J1le+RsrACJN2EdsMGLhBYPaddgjL40RxQTSO9nm1aD7ojJSDNmbsQF54GaOXPF+bGSDPYweC4um1+PDtNskVzcc69xp9BGEC5JjCaT+aPs4uhD4gDNcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBv09+wHiBWsyqnh3cBLoXYqvmu11IDu5rqdQR0b3wI=;
 b=Mou27S3Z3m3yVlBlFSHNGKP2uqqGVM+qxheUXJPmX75yWgckOc2dTSujBYzbqmkLhM6yWFTyRgYJzeJydDR6Y9IMl6BX6a4R+25pi39yWj5tOa8mmV+Er7qaFVqf3ZuKtmZWbtE3Fas1cMoSGsZyR9vm5RqJPWwcK2Kq6A+4310BFXVNk7inKIOuDhoQHgZK8YhOS0SPA5Wo17/n2Yrpc6UtsJ5RZ9JvOpSt/vCelldq5fedXXMyRui3obUR5a8V3aM9zgASepS3fH9IQ8cvHS1Pi1I1ViULRsnmVq33mpy5v64UdwCcsi8hWA1QOBj3WXGmTifXPbwH4JcJ7z8IKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by KL1PR0401MB4449.apcprd04.prod.outlook.com (2603:1096:820:21::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Mon, 21 Nov
 2022 10:36:11 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::6077:fef:aa50:920e%7]) with mapi id 15.20.5857.017; Mon, 21 Nov 2022
 10:36:11 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     Vincent Fu <vincentfu@gmail.com>, fio <fio@vger.kernel.org>
CC:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>,
        "Kento.A.Kobayashi@sony.com" <Kento.A.Kobayashi@sony.com>
Subject: RE: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Thread-Topic: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Thread-Index: Adj4yimqLnbaVLwfS9mikvNy15l48gClO0eAAIz+hdA=
Date:   Mon, 21 Nov 2022 10:36:11 +0000
Message-ID: <HK0PR04MB23882A7010C577D1EA34FB57FD0A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
References: <HK0PR04MB23884FFF415F7EFCB424CABEFD049@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <7c4b684c-03e8-9f33-3809-443ac7678a07@gmail.com>
In-Reply-To: <7c4b684c-03e8-9f33-3809-443ac7678a07@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HK0PR04MB2388:EE_|KL1PR0401MB4449:EE_
x-ms-office365-filtering-correlation-id: 5f2a5c80-5ccc-4b94-6b90-08dacbac3528
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 45QFZCFu376XuEWYB4+7Zq8sn1GENHtJexIN7VAOZYcnV6J9ey67849eQHS22UQ5/EMz7eeYG32P3vdffz3xkfcpzQ0PnVCmSMDaDr8RUALtM1xp2hL269RgKadAbdp7dIP/qs7gOUDxV3sCJD1TZlIJzTpjTaClTfSE5IKTSdsSXinUuUaGn4d3o9af5gnhMeYno4a7LDodAEuXy+PEZA0OrzAduZGuFVlSOcVZ//oTtXlN46cuPDWEymTThlCSf3XpJMEwtHj9iwHyF+9quUGtpZX/12UleGZ/NnitK/sz5ced5RDo0h8xHD9EkRyLIlouDRwG+840UsKwwnmImwiaf15+6FK93oxaRk3scJ0JK6tzzEQ6TClsErppIlthZq0LGtQPvwDU5FTcwy6LaD9auo5sjJVyI/lI4smZEEdSqSr9fza5JQ46Dq8gtnRFYIPqIF9V6dit/3MQMO1SN4eWMXBEOxm81gORaEdEtIc9GuCpx2EsM2Q79X+JpT/P2Lby6gaVAyM+YMjcKHhtecU0iigtgaKd3yosIIZ326+3DvZX3aBTCpTcUQsEY8gJL3J5FwsxXHB+5Ff3hzWPjQD2LTmUYTi984z+qPiHpWaMsHZole/ZOUOmyL8k5FLg+NlhS05IFmPEFgbp1CVsAMtfDf7BSAdH14h445sG6xd2uo/dgIG+RPAWgxSlGWkE/uRNmo+B7rD3C3BZW9aGCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(41300700001)(76116006)(8936002)(52536014)(316002)(54906003)(4326008)(66476007)(66946007)(8676002)(64756008)(66446008)(5660300002)(66556008)(86362001)(82960400001)(71200400001)(55016003)(6506007)(83380400001)(38070700005)(478600001)(26005)(2906002)(110136005)(107886003)(186003)(7696005)(9686003)(33656002)(122000001)(38100700002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YityNlZLM0tOYmlBSDU4eEI5Q0NsTE9LVnI0Kyt0YXp6aUJUVUxQOXU3NTRK?=
 =?utf-8?B?eGw3T3BURXlOWU5oRXhPaEx4WXZBbG5LYWYzSkM5MlNqaVFXOHd0NXdseEdt?=
 =?utf-8?B?eHkrV2lYc1B3eEd3MjRKblR0dnQ1bENhaVdHNnJxN25XVUx4RC9sVnBxcE92?=
 =?utf-8?B?ckJTSVN0ZEkrcHN1L0QyUnBYd25KeXJFb3V2a1lCZDNaUHVnMS9Tc29JQ1pX?=
 =?utf-8?B?cTNNeUFIdHUxM2R6elZrTldpZkFlWjBMNzNIcGdWbGQ3Q283d3NBUmM5Zis5?=
 =?utf-8?B?cUgxMTBSQXl5eDVWMWtqYitLYjBNd3R1dk9mbGo2ZVN0RlNRSUpjRG1abmlt?=
 =?utf-8?B?cmFYZStFWkJhbE1YcS9kbU1kMmo4d2RTa2FnMWtGc2FCL1BmZHNiS1hUNzB5?=
 =?utf-8?B?TzRQZklHdUdaQ1BUaXd5MW05WmlCdjNBRVlXc0VuVHVQZG1laHgvc2FsZ1hI?=
 =?utf-8?B?WHZ1aWVKWDdXSVY1bGRLejhLK1huNUYxbFZxaGRYbnk2aWVqbU5CbDk0VDF4?=
 =?utf-8?B?ZzFpM1BFcnZzRHJjL0pXa29DS2dISkd5WnI4ZWVwcjRIa2xYcitrTXdhZEZ3?=
 =?utf-8?B?R0IyWFNodHZ6aFdPNlEwL1pRNlhqU0tUcHVBaHUwYjRqc0RtZnd3MTVMb21q?=
 =?utf-8?B?Zk5wMXhlNlNMWTZlSVVNL1BIcXhQV01tN2tobWl0SVIxT3ZjbVJIZm9WaUhy?=
 =?utf-8?B?blJhMUhVLzJjcHlyNER1UTNPcE5YOGI2clQvNHpwNis3QTJVZUtiaDg5V2NV?=
 =?utf-8?B?c21tOXdGY25YZWVMci81Tk4rNmR3eFN2dHZKK2UrNDhqZThwSW1weXpobm4v?=
 =?utf-8?B?b2lSVEp5SVhNa1dTQy96V0NtZlFhdVlyWXBMWTZtMXUraEhQZHNFZ0lIREZO?=
 =?utf-8?B?YU1Qa0lhMThQR2xoQUlEbTFiVzBxVU55dTJ5azF4TGxYc0hNc3JualVOc1lz?=
 =?utf-8?B?UDdTTEgrZmFJVkNrNzVaRG82RUdYK0M3YXg1cERLcFBHQVArTFd1MXFuZXpP?=
 =?utf-8?B?L2xJZG5pMXEyM1NGVzNwcElTZjl5aHdiOVR2aDQ1dFYxdnlkaERGRXhSVjF4?=
 =?utf-8?B?MXdGRm5OUExBRDZ0aGNsM1V3OXJzeWJuNzJsemo3RzFwK09FYlYyRk9CTWUr?=
 =?utf-8?B?RU1NOXprOVRTbzJ0VDYrRTBFQXNtVllDb2N6SnlnWmd5V2M3aVg1cVRBTDNB?=
 =?utf-8?B?R1ZLL1I2TE43MXk5VU5USHZFZ3dnVzBINmtWMi92dnJUczdvOExUM1VxUnRO?=
 =?utf-8?B?bU00a1lZZzhKelZuV3huaHNPcDBhS1JwZUN3cVgzREYvTjFLWk92SmJNcUJo?=
 =?utf-8?B?S0prVEhLc3lVWjZLYzF3elEzM1lHRVVMYnZZL3NrWm83eGtIQmNMVlB4WXF4?=
 =?utf-8?B?OVdSMmxIMWM1dGJYMGJrVTVzdjVpSS9lVkdFYklZQ2JSSm1yNHBUMzNaWEhz?=
 =?utf-8?B?dC9JckFrbEI3UmFPblVVN0t5M203cEJJVjVYNTBmZFkwMFpuZ1pHa2drK05W?=
 =?utf-8?B?cE4yOWtUTlBIVVNjRVJWeUZMVVpRckpNS1NwT3liRmlYMURtVkZjT250WllX?=
 =?utf-8?B?QzlQa2Y0UWlUZVhOQURXWlA5a081K2tGK2ZLOWhYNmxYRU43c1lneGMyWEdr?=
 =?utf-8?B?ZVZWdFZoRElXd2t2SmVZTERTMjNiaXRUcjNhaHRFb0NROENRL0JONjNCSkp1?=
 =?utf-8?B?a2xwc3pGWkVVeE5kOHFuL3Q3ZWpKT3IxeHp5THJwTkN5S3FsUEFoWUlMSTRH?=
 =?utf-8?B?VnZ3eWFvTEN4eFRSQTlXSHhnVFBPa3JTS3lHQ1pma3VWTTlMbTdBSXExeGFC?=
 =?utf-8?B?OC8xaXVwams5cUxyczlCVWU1NEtrc292MitVMlBvVHFPQlBUd2R2UUxndWts?=
 =?utf-8?B?WUg4TGUveW9nWlpoSkJTVnc2WTBxZkwyNHpFTUlLU1BEQmlXYUIxYlRxbzZa?=
 =?utf-8?B?cmtVRmZkNHFUU1JSZ3VwOER5clJwQnRmeHRvdGdGRTluUlNHNnEwNnpnSWU0?=
 =?utf-8?B?eVRXcFlJV3kxaTBheUdGMkRIdG5XTW9Mc3hITHA5RmlTUGFpZFFBSnlHWjlT?=
 =?utf-8?B?V1BoVnlXdndqVkx3aGh4a3R4VURvNTZ0cGtlQzQySUx3YjZ1THhRZnpMdEFR?=
 =?utf-8?Q?ypGwaWCRM7XnbX4IEv0BFg7Qt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +/oPvSbCvv2tJzT/qJFUDE2bLvZsjOY7g8pGaUlnKo9PBXGfb+Wi62GQIAewqMFmNa8iRhRnhjFiqf/QQe3ZQt14edCkD3IhQHLOcfHoc83sf6bs6VKMEG8L8PK8dTXEQ3EDoQkAo7qg6+oIME3tl5fDrKcYaOCaX3ljqWjsV5Sb9F1exIrUTmBAwj8Szes5gQ/HgX5mV3wgZyDOBGzQMKny/RDMqzM2ITLmHyhpzAbwoh4LnZlqapQRP80KFynsdNMe46HcVC5qeUOpIizPer0vaqI0rYSi6Xy2OyWSZGxW7Z3Ncva3Ab7E3T6TyyG8lLqVqXWR8mYzhW84cAHbDKUJ8/O/a2kZrZ3TJQj4r+WVYRav+avl1h5qO9DHXNFemz4I22ml+Ct2PJ6YRN3ZKeo2lTxlSmHg2lA/eUxT685jDGB9jxenxnHlTTkwa+bMnAJEsSb9Ukvg7sNlHlM3smg5BRIMlO4W3GiNYAo9zXyzMhWBUfNjUiDgWERzET5/EjL/9PRrZl/F4qjQuqBvMNPpXdbQ3ep9BBXzYPswbknFjs1nhcyNLvjxC1HT5zzZjBML4nTZoBg58966N7QqD1XxH0ZiEigq3rYM6JcSbOG2OkpvvTbdqzg27ELLKFmEPi9DcxQTF31DToBG/rpooBX0UWCQSxD4A71jE1F2ponki2k6gj52vv87n5C08s8vEPLts96U81RO5XQ/OCjuZ7i/S1xS82bA9c2PLD5BtKwMvnQwgyy7RusxYxbuZ9tDtzOCFpPSASaoP6D5vI+bVlVNsFjt2VxMmgBgsFpx8rkbI2KzgZIJurnCf9cGRoQg
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2a5c80-5ccc-4b94-6b90-08dacbac3528
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 10:36:11.2845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DUWUUlSxhByN6x49z7tR2LKuzUCZ2lMTkrhwIjkPRYyEp16aLl8c+LwUnt/EpujZr99RcPFBU9KxgV18bw3/5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0401MB4449
X-Proofpoint-GUID: DeaAaFpfrGeiR0DfAeV9-RMn4dKC51Tp
X-Proofpoint-ORIG-GUID: DeaAaFpfrGeiR0DfAeV9-RMn4dKC51Tp
X-Sony-Outbound-GUID: DeaAaFpfrGeiR0DfAeV9-RMn4dKC51Tp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiBJIHRoaW5rIGhhdmluZyB0aGlzIG9wdGlvbiB3aWxsIGJlIGNvbmZ1c2luZyBhbmQgbGVhZCB0
byB1c2VycyB0cnlpbmcgdG8gDQo+IHJ1biBhIGpvYiB3aXRoIC0taW9lbmdpbmU9cHN5bmMgLS1y
dz1maWxlY3JlYXRlLg0KDQo+IEhvd2V2ZXIsIEkgdW5kZXJzdGFuZCB0aGUgY29uZnVzaW9uIHRo
YXQgYXJpc2VzIHdoZW4gdGhlIGZpbGUgb3BlcmF0aW9uIA0KPiBpb2VuZ2luZXMgYXJlIHVzZWQu
IE1pZ2h0IHRoZXJlIGJlIHNvbWUgb3RoZXIgd2F5IHRvIGhlbHA/IFBlcmhhcHMgdGhlIA0KPiBp
b2VuZ2luZSBjb3VsZCBlbWl0IHNvbWUgc29ydCBvZiBtZXNzYWdlPyBPciB0aGUgZG9jdW1lbnRh
dGlvbiBmb3IgdGhlIA0KPiBmaWxlIG9wZXJhdGlvbiBpb2VuZ2luZXMgY291bGQgYmUgZW5oYW5j
ZWQ/DQoNCkkgY3JlYXRlZCB0aGlzIHBhdGNoIGJlY2F1c2Ugc29tZWJvZHkgc2VudCBtZSBlbWFp
bCB0byBhc2sgd2h5IHJ3IHN0cmluZyBzaG93cyAncmVhZCcgd2hlbiBoZSBtZWFzdXJlZCBieSBm
aWxlY3JlYXRlIGVuZ2luZS4gQW5kIG1vcmUsIHVzZXJzIGZlbHQgc3RyYW5nZSB3aGF0IGRvZXMg
SU9QUy9CVyBmb3IgZmlsZSBvcGVyYXRpb24gbWVhbj8gDQpJIHRoaW5rIHdlIGNhbiBkbyBvcHRp
b24gY2hlY2sgYXQgYmVnaW5uaW5nLiAnLS1pb2VuZ2luZT1maWxlY3JlYXRlJyBhbmQgJy0tcnc9
ZmlsZWNyZWF0ZScgbXVzdCBiZSBwYWlyZWQuIElmIG5vdCBwYWlyZWQsIGVtaXQgZXJyb3IgbWVz
c2FnZSBhbmQgZXhpdC4gSG93IGRvIHlvdSB0aGluaz8NCg0KVGhvdWdoIEZJTyBpcyBkZXNpZ25l
ZCBmb3IgSU8gbWVhc3VyZW1lbnQgb3JpZ2luYWxseSwgZmlsZSBvcGVyYXRpb24gcGVyZm9ybWFu
Y2UgaXMgYWxzbyByZWd1bGFybHkgZXZhbHVhdGVkIGZvciBmaWxlIHN5c3RlbS4gSXQgaXMgaGVs
cGZ1bCBpZiBleHBhbmQgRklPIHRvIGFkYXB0IHRvIGZpbGUgb3BlcmF0aW9uIGJlbmNobWFyay4N
Cg0KRnJpZW5keQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmluY2VudCBG
dSA8dmluY2VudGZ1QGdtYWlsLmNvbT4gDQpTZW50OiBGcmlkYXksIE5vdmVtYmVyIDE4LCAyMDIy
IDExOjA1IFBNDQpUbzogU3UsIEZyaWVuZHkgPEZyaWVuZHkuU3VAc29ueS5jb20+OyBmaW8gPGZp
b0B2Z2VyLmtlcm5lbC5vcmc+DQpDYzogQW95YW1hLCBXYXRhcnUgKFNHQykgPFdhdGFydS5Bb3lh
bWFAc29ueS5jb20+OyBLb2JheWFzaGksIEtlbnRvIChTR0MpIDxLZW50by5BLktvYmF5YXNoaUBz
b255LmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggdjFdIGZpbzogQXBwZW5kICJmaWxlY3JlYXRl
L2ZpbGVzdGF0L2ZpbGVkZWxldGUiIHRvICdyZWFkd3JpdGU9Jw0KDQpPbiAxMS8xNS8yMiAwMzoz
OSwgRnJpZW5keS5TdUBzb255LmNvbSB3cm90ZToNCj4gU2hvdyBjb3JyZWN0IGZpbGUgb3BlcmF0
aW9uIHN0cmluZ3MgaW4gbG9nLg0KPiANCj4gRm9yIGZpbGUgb3BlcmF0aW9uIG1lYXN1cmVtZW50
LCAncncnIGZpZWxkIGlzIHNldCB0byAncmVhZCcgaW4gam9iIGZpbGUuDQo+IFRoZSBjb3JyZXNw
b25kaW5nICdydycgaW4gbG9nIGlzIGFsc28gJ3JlYWQnLiBUaGlzIG1ha2VzIHVzZXIgY29uZnVz
ZWQNCj4gc2luY2UgZmlsZSBvcGVyYXRpb24gYW5kIElPIHJlYWQgYXJlIHRvdGFsbHkgZGlmZmVy
ZW50IHRoaW5ncy4NCj4gSW4gdGhpcyBjb21taXQsIGFkZCAzIG5ldyBmaWxlIG9wZXJhdGlvbnMg
dG8gJ3J3JyBmaWVsZC4NCj4gDQo+IEZvciBpbXBsZW1lbnRhdGlvbiwgVERfRERJUl9GSUxFQ1JF
QVRFL1REX0RESVJfRklMRVNUQVQvVERfRERJUl9GSUxFREVMRVRFDQo+IGFyZSBhZGRlZC4gTWVh
bndoaWxlLCBERElSX0ZJTEVfT1AgaXMgYWRkZWQgdG8gaWRlbnRpZnkgdGhlIGZpbGUNCj4gb3Bl
cmF0aW9uIGFuZCBJTyBvcGVyYXRpb24uIERESVJfRklMRV9PUCBpcyBzYW1lIHZhbHVlIGFzDQo+
IERESVJfUkVBRCwgdGhlbiBjbGF0X3N0YXRbRERJUl9GSUxFX1JFQURdIGNhbiBiZSAnYm9ycm93
ZWQnIGZvciBmaWxlDQo+IG9wZXJhdGlvbiBzdGF0aXN0aWNzLiBKdXN0IHNldCBERElSX0ZJTEVf
T1BfTUFTSyB3aGVuIGdldCBpb19kZGlyX25hbWUoKS4NCj4gVGhpcyBhdm9pZCBiaWcgY29kZSBj
aGFuZ2UgaWYgYWRkIGEgbmV3IGluZGV4IHRvIGVudW0gZmlvX2RkaXIuDQo+IA0KPiBXaXRoIHRo
aXMgY29tbWl0LCB1c2VyIGNhbiBleHBsaWNpdGx5IHNwZWNpZnkgdGhlIGV4YWN0IGZpbGUgb3Bl
cmF0aW9uDQo+IGluIGpvYiBmaWxlICdydycgZmllbGQuICdydycgc3RyaW5nIGFuZCAnZGRpcicg
c3RyaW5nIGluIGxvZyBpcyBhbHNvDQo+IGNvcnJlY3QuDQo+IA0KPiBFeGFtcGxlOg0KPiANCj4g
JCBmaW8gICBmaWxlc3RhdC1pb2VuZ2luZS5maW8NCj4gdDA6IChnPTApOiBydz1maWxlc3RhdCwg
YnM9KFIpIDQwOTZCLTQwOTZCLCAoVykgNDA5NkItNDA5NkIsIChUKSA0MDk2Qi00MDk2QiwgaW9l
bmdpbmU9ZmlsZXN0YXQsIGlvZGVwdGg9MQ0KPiB0MTogKGc9MCk6IHJ3PWZpbGVzdGF0LCBicz0o
UikgNDA5NkItNDA5NkIsIChXKSA0MDk2Qi00MDk2QiwgKFQpIDQwOTZCLTQwOTZCLCBpb2VuZ2lu
ZT1maWxlc3RhdCwgaW9kZXB0aD0xDQo+IGZpby0zLjMzDQo+IFN0YXJ0aW5nIDIgdGhyZWFkcw0K
PiANCj4gdDA6IChncm91cGlkPTAsIGpvYnM9MSk6IGVycj0gMDogcGlkPTQ3NDQ6IFRodSBOb3Yg
MTAgMTg6MjQ6MDAgMjAyMg0KPiAgICBmaWxlX29wZXJhdGlvbjogSU9QUz0yMC4waywgQlc9Nzgu
MU1pQi9zICg4MS45TUIvcykoODAuMEtpQi8xbXNlYykNCj4gICAgICBjbGF0IChuc2VjKTogbWlu
PTEyNjQ1LCBtYXg9MjkzOTQsIGF2Zz0xMzc1MS4zNSwgc3RkZXY9MzY5MC41NQ0KPiAgICAgIGNs
YXQgcGVyY2VudGlsZXMgKG5zZWMpOg0KPiAgICAgICB8ICAxLjAwdGg9WzEyNjA4XSwgIDUuMDB0
aD1bMTI2MDhdLCAxMC4wMHRoPVsxMjczNl0sIDIwLjAwdGg9WzEyNzM2XSwNCj4gICAgICAgfCAz
MC4wMHRoPVsxMjczNl0sIDQwLjAwdGg9WzEyNzM2XSwgNTAuMDB0aD1bMTI4NjRdLCA2MC4wMHRo
PVsxMjk5Ml0sDQo+ICAgICAgIHwgNzAuMDB0aD1bMTI5OTJdLCA4MC4wMHRoPVsxMzEyMF0sIDkw
LjAwdGg9WzEzMTIwXSwgOTUuMDB0aD1bMTM3NjBdLA0KPiAgICAgICB8IDk5LjAwdGg9WzI5MzEy
XSwgOTkuNTB0aD1bMjkzMTJdLCA5OS45MHRoPVsyOTMxMl0sIDk5Ljk1dGg9WzI5MzEyXSwNCj4g
ICAgICAgfCA5OS45OXRoPVsyOTMxMl0NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IGZyaWVuZHktc3Ug
PGZyaWVuZHkuc3VAc29ueS5jb20+DQoNCjxzbmlwPg0KDQpJIHRoaW5rIGhhdmluZyB0aGlzIG9w
dGlvbiB3aWxsIGJlIGNvbmZ1c2luZyBhbmQgbGVhZCB0byB1c2VycyB0cnlpbmcgdG8gDQpydW4g
YSBqb2Igd2l0aCAtLWlvZW5naW5lPXBzeW5jIC0tcnc9ZmlsZWNyZWF0ZS4NCg0KSG93ZXZlciwg
SSB1bmRlcnN0YW5kIHRoZSBjb25mdXNpb24gdGhhdCBhcmlzZXMgd2hlbiB0aGUgZmlsZSBvcGVy
YXRpb24gDQppb2VuZ2luZXMgYXJlIHVzZWQuIE1pZ2h0IHRoZXJlIGJlIHNvbWUgb3RoZXIgd2F5
IHRvIGhlbHA/IFBlcmhhcHMgdGhlIA0KaW9lbmdpbmUgY291bGQgZW1pdCBzb21lIHNvcnQgb2Yg
bWVzc2FnZT8gT3IgdGhlIGRvY3VtZW50YXRpb24gZm9yIHRoZSANCmZpbGUgb3BlcmF0aW9uIGlv
ZW5naW5lcyBjb3VsZCBiZSBlbmhhbmNlZD8NCg0KVmluY2VudA0KDQo=
