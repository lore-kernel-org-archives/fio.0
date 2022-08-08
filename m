Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68990C3F6B0
	for <fio@archiver.kernel.org>; Mon,  8 Aug 2022 08:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiHHIms (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Aug 2022 04:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiHHImq (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Aug 2022 04:42:46 -0400
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5273A13E98
        for <fio@vger.kernel.org>; Mon,  8 Aug 2022 01:42:45 -0700 (PDT)
Received: from pps.filterd (m0209325.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27863DEt020636;
        Mon, 8 Aug 2022 08:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=mWBOz3AxRTT/d9Ng0TAlofGD6z9ibhd/3gdw2D9aT+M=;
 b=dEyymX+j26lZ+4VA57lnHnmYjrj1aUZN6DDwHz6y2t/VtHfs1K6R47PLeHjhF4kb3dNJ
 0HT6gYiQ+cq8vTokqPSY5zdX2mE8JpFwJp7ltrf3dHbI6a+IggvV+y1iRphLwPbs6wi0
 d7mygVy8LI7V6VfoHQGdIdWcl276iP5QYnSA9ig9tgwVi+FJqIhhM6Jb5FcGmSV7g3wy
 IVbBdXLtM/SO8O2nZuDY7l48J+kleO1ki5EwuFaBjNb9m3rTqCLaunRjrvQxSRt+TcFn
 xlgqVZ/dyP1MbPuwDQdfL74Gu7ndnZw00TBm7YoTn00Ic9kq3a+H7I3aTDlP3Yq69uwu qw== 
Received: from apc01-sg2-obe.outbound.protection.outlook.com (mail-sgaapc01lp2113.outbound.protection.outlook.com [104.47.26.113])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3hsdhysq39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Aug 2022 08:42:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fg2vO3nueqcrvNcuxd7DAT2yYkRtywfB6wrts39jVAPvoNEYWrEFEceILFqD/WdAcrKlJkbXaLuVcDFHWP7yNjkUm7OkRnVQN7st0RfT2MHv1EuxFXO1HFCbB1OWpl3IsXasJUfFChgjsVHifcdQC8Z/EiXwG/iWL4HIkPViZ00Jzpwpm/PkNbqZhM04QaW5QV3LDfedZ6Jj231Md1sBFuCv4zsa7uwySST/Pc8Cf73MVcvDcHxG/yAIBNjohiHlnC7CzmLA0HaMYFth+NcT++pA0HqXFQWRY6aUVcTAPCfKoFrqqtqLvSnl/jk/AngcGuDU1DuthDjZZrJLrV8fAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWBOz3AxRTT/d9Ng0TAlofGD6z9ibhd/3gdw2D9aT+M=;
 b=Cdn/Epw1Aq2EiGUkyuu/w0V3sm2YzeEjt06lxDRtZwk5jCD8Gic0Y+1vIV1nwlaKuDgdb32PIVgjyKl7i7GcdDBCln80bEuhDpA8t/A3XJNZI9789zlRKB38CqKvR4LMWLFW4PngKay/Ltmj2yKefYrVJzUB0egveNhdIXJenRiUAfNRh+uYO10QG/YpaCTh2TD46nDMIeg7KFBYLnr9nZqqHBewdrHxRvfzTx1IHHUqWUxiPLFNrnBCBT5weHDhhAKCV/34IQiIRfkscs2tEPAHVUczycuWz9zH1M4KLWHCgBA3ARgVgPazki4ZOVanFsn1whegvdr9pbINvwvrkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by SEYPR04MB6604.apcprd04.prod.outlook.com (2603:1096:101:c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Mon, 8 Aug
 2022 08:42:36 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::ad41:9b0c:99d:76f8]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::ad41:9b0c:99d:76f8%7]) with mapi id 15.20.5504.016; Mon, 8 Aug 2022
 08:42:35 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     Vincent Fu <vincentfu@gmail.com>, fio <fio@vger.kernel.org>
CC:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
Subject: RE: [PATCH v1] ioengines: merge filecreate, filestat, filedelete
 engines to fileoperations.c
Thread-Topic: [PATCH v1] ioengines: merge filecreate, filestat, filedelete
 engines to fileoperations.c
Thread-Index: Adilc6ZtyCoBTMSpR7i69Cx3/5QVjAB2yKiAAOz57FA=
Date:   Mon, 8 Aug 2022 08:42:35 +0000
Message-ID: <HK0PR04MB2388822B8606BF29C0056A90FD639@HK0PR04MB2388.apcprd04.prod.outlook.com>
References: <HK0PR04MB2388AF0A140EE14FAF3604BAFD9A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <f0a02d35-4ac2-7e6c-9669-e782acbe593e@gmail.com>
In-Reply-To: <f0a02d35-4ac2-7e6c-9669-e782acbe593e@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35a01433-7577-4042-0d23-08da7919f173
x-ms-traffictypediagnostic: SEYPR04MB6604:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ic9cIsSnBAm+SuK/4n7UH88MoTTv9tVcvEWiR2Cie5F8RfMNF5GDl5n6n6pO3FBT1O3C+5wmlBZCJm0yyvD+B+fs5LjkwXjFDiov9BItbQUpOR8n/BpjV4OaF71s/3m87Z4w0ZSJZ28KaC4QciG5tfSIkzD9JOet9QBjZqGxRxhGQNJSxtbxc+BChGLTHm20v6kaRfgxZPxF3gKv5LeE526LkRDvUE4Q9oc8RG3G49ouiaXPdGAhD0CG/2Q3xeaoNpz9f8zC5RnMgF9oX6oZTmkM1q1b1kU9nqWKZvM9Rkj8BBKeFkVg3kpMY2yaIzQ9Tj7WUyUUrpn6hkuAoHDuBBpqyF624J7/dT5V7eABqeaKZbgH3qe0+t7qsG+zTmmfGY/eTEGNFlNEYiDSzaYVszHK1DFwDXW/H3McQpjKAencvPey2PI8pZHvPYpDpj58fZE0A0TiMd1WbwigXncCXh/pBN+642X1qQmvwl6vgwLrsgNTT3a9WuCN9mhDLvR8pVfWhKX3nayesMx00ABgMwRyoRIDh07VmEzqVmeulfGNeiwni7Y3ylimFT/JHUxjfKpOWUk/sX57BIj/Tw81JeMYlxw4OqOsF0XOqc8u2gtJoDCxGViL1Iban0S6xCoVBT1dJ7vjXXy+5nIpo21I/hbhzzPifvszrnqkdLau8uAtdbKWHV+31S1W/aeuV5Ek9hmxR134PBYAK3fA1xi0sMt5z/RLpHyeUUy4JVzNiWzk4vHwehDiNmnrB7SsOpUDxBx031J/lGgHfR0XVZcHdTKLpX1oQ1rRcEbuainTbF+UnwwpQufE2Jr6czo1RmXQXr6FaFaHiMZW5XyVUoSdUFvvHIP952T61kgh/ekUQCU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(316002)(478600001)(110136005)(71200400001)(966005)(2906002)(55016003)(8676002)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(4326008)(52536014)(5660300002)(122000001)(8936002)(38100700002)(38070700005)(82960400001)(86362001)(9686003)(33656002)(7696005)(41300700001)(186003)(107886003)(83380400001)(26005)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3dxcnh0NFZrWm9LdVdxRkNaV3Z5bStuUWY1TWNqeFJMa2hVY2FJSzZuSjE2?=
 =?utf-8?B?UHNzeEpZaWlRVnhTQ1lSUXVEV01Uc1dkN1lEVmdmRWM3WXQvaTJmR1F3a2ZM?=
 =?utf-8?B?SDByR3JMdDE1bGFoWm0yNHJUbXdxeThXRzlmQUliSmYrS2E1c3V1Q3VpQlNZ?=
 =?utf-8?B?UWdRTGtpVXkvR1RUSkRtODZrc1E2cU1FSjNVV2pISUkrbTc5NFVwRkFMMjJ5?=
 =?utf-8?B?bzlYZk1uMlB2QzllWGFwWEJqalRKcDBzTDRzOUtsM25uWmtXUVVsekIrRDd1?=
 =?utf-8?B?YXBpSmVKbXVhRWpCdXpOVHhnb2tTM3VTMXVLRE1SR2wrVjBCRnJPRHB1Zkx5?=
 =?utf-8?B?Z0d6K0dpYUNBS1JYNkRPVExkVG8yU3FIekJFdTVEakx3MVN6RTQ1N2FpTEJj?=
 =?utf-8?B?TlJGZ1djNll5QjU1aGVUelQvTElocTJvM1hFNkllM0VQSEJocm5HYWpZWmli?=
 =?utf-8?B?MjFJcThRVm5CSThtZ3ovUURGdWMzZmxxais3ZEJhcWFxTklBRW1PMGl4YTNS?=
 =?utf-8?B?ajFwWnNWTUszRmZvYjZGMkE2azllK2lBbEZIam5kTDJmRkNOQVRTVFR1QjRG?=
 =?utf-8?B?RWcrN0NsaWM2SVByYUtlNTV1TW4rWHJLeUFUQWVyZjRqd2hYR21OdGkvTHlP?=
 =?utf-8?B?bW0rdmJWS2c2NzJuT1ExL0pTeHFCeWJsZzF6eHBvSzMxcHo3VWRIalhkTjd1?=
 =?utf-8?B?b2tnSGVoOFJ2UEZhUlQwZkJxUHdMc2JWS1pwWjVHVWlXN28rNFBlRnNlM1A1?=
 =?utf-8?B?MzdjeGpTTzEzTUpoUS9EUnBwK21YNVQzTzVUL01LNTRYRUtMNFpoaXVsakY2?=
 =?utf-8?B?empBNlpycmttL2tjTkRiV2c0SVhUOXlIWHovajRnaGFjejNuZC9QMnBYMTlO?=
 =?utf-8?B?eHpEK0NVYUJoODV2UEE2cTh5b1pOL2p2UG1FTVBkTXhwbjlpRWh2Q2dVeGxE?=
 =?utf-8?B?Ky96TkxMNUxjK0ZBWVdjcVVmQ2tSMmRTeFBCQUg2M3BISVpyZk9FNkJmd3Jn?=
 =?utf-8?B?RktzeWR0KzZjZUwwb21ua0Q1TFF2bWpiUXQ2L3BrSGhoNEdBNXFJVEtaZnBl?=
 =?utf-8?B?aE5JMk1XZDdGR0tmVU1Qa2IyTytlMzNjMnJtZURzbUMrenpFYUxUMXlFTFdh?=
 =?utf-8?B?b25QTTZTRnEzTmxNcEJRaEtDSjBOMm9SRmFZd2JNeFFqODZpaFpXSDRXOTJK?=
 =?utf-8?B?dHk4dmhUY1RiLy9WS3hRYkNlcDR2M2w2akYrTU91dW05eWN3WDUzSktMY0s3?=
 =?utf-8?B?Y2JiVjl6a1gzRVlrKytoZTMrVDY4Vmw1dURFUlc3ZlNzZ2grWE9TWkpDMWFX?=
 =?utf-8?B?NFpWMWd1Zlo0OHB4WUN1RCsydW9OYVIycG9qZFRpQTYwRHg2NmtBblZYaVdM?=
 =?utf-8?B?b0JKbjNBMG5HRWg4SHZnZUVKNjR2ZlhoVUFIMm5ndWdGaDVCYWFHaHd4TE9R?=
 =?utf-8?B?THpuZ1ZrS0NSQTZkN2QvK2gydmJPbDdSYWJMc25vZUpHdm50ZHEzNzdkeFFH?=
 =?utf-8?B?bmJtdHE5SjdqN0VSQ2lEUTdKVk5nd3liOHdUMWpMT2FsSloxLzhhTGJGVlF6?=
 =?utf-8?B?OXltYy8wZjYrSXp6ZlpucDRkTlFaUjlsTGZjWjVPTk9MQ1hZNDErTU1qbFVX?=
 =?utf-8?B?bEtFMEVLTkJqWW5NNnVUWnE4dlczeThjTGk2OGpZTVRpaHJQbGpEUmFkSVNo?=
 =?utf-8?B?akY2b3ZmWHhnOFhFdTYralZDQ3NCeXNzRVlFME9DZzhPOEJFdDdwdE90SVdp?=
 =?utf-8?B?VTBSUncxbEJwa2o1S29HZzRuOXdEbW5Id2ZzVWtoVU9aZWZveEFOYnU2cUc5?=
 =?utf-8?B?bXlteWNycmJaMkFDcFNxWVIyNWJDVWwvaXpKZHhDQjIrNTB2Z1g3M0lXUVJy?=
 =?utf-8?B?SG9pNUs0RXlPVldXNkxqZTJZT09BZzQ4NjVwa09RdGlkMVhYM0xQQWg4UFFT?=
 =?utf-8?B?Zk1tZmdCRWtlMUluTU9BVnBubDc2QXhEYk5taFNUZVJyVFROQjZXUTBTQWsy?=
 =?utf-8?B?emh2WVlmemhWVXliS01rRmpmTkp1WENKSlp6ZkxOY09WMFZaM2tkNlVlaS91?=
 =?utf-8?B?TE5zNE51TEZJMlpwZjd2ZkFDV1htZXBqaDNQYTFXOU9hOVQ2UkI0OXFybXZS?=
 =?utf-8?Q?BCinKRu0j6dmmb7k4335xvR5y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a01433-7577-4042-0d23-08da7919f173
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 08:42:35.7870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ldBgWYu8CwoEAAD3PEtPUiBLI7eGeHd+H3h2LQ1sX/6UQSAb5dY3WvRxVtg1dkOXbG4N8bw9ouMlrdipgI9ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR04MB6604
X-Proofpoint-GUID: 4uOdggKUUKb0UTyIT4_5DfgyX0uDxbBp
X-Proofpoint-ORIG-GUID: 4uOdggKUUKb0UTyIT4_5DfgyX0uDxbBp
X-Sony-Outbound-GUID: 4uOdggKUUKb0UTyIT4_5DfgyX0uDxbBp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_05,2022-08-05_01,2022-06-22_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

SGVsbG8sDQoNClRoYW5rcyBmb3IgY29tbWVudC4NCg0KU29tZSBoZWFkZXIgZmlsZXMgYXJlIG5l
ZWRlZCBpbiBDSSBidWlsZC4gSSBhZGRlZCB0aGVtIGFuZCByZXNlbnQgUEFUQ0ggdjIuDQoNCkxp
bnV4IGJ1aWxkIE9LDQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9mcmllbmR5LXN1L2Zpby9hY3Rpb25z
L3J1bnMvMjgxNjI5MTk4NQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmlu
Y2VudCBGdSA8dmluY2VudGZ1QGdtYWlsLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCAz
LCAyMDIyIDExOjM2IFBNDQpUbzogU3UsIEZyaWVuZHkgPEZyaWVuZHkuU3VAc29ueS5jb20+OyBm
aW8gPGZpb0B2Z2VyLmtlcm5lbC5vcmc+DQpDYzogQW95YW1hLCBXYXRhcnUgKFNHQykgPFdhdGFy
dS5Bb3lhbWFAc29ueS5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIIHYxXSBpb2VuZ2luZXM6IG1l
cmdlIGZpbGVjcmVhdGUsIGZpbGVzdGF0LCBmaWxlZGVsZXRlIGVuZ2luZXMgdG8gZmlsZW9wZXJh
dGlvbnMuYw0KDQpPbiA4LzEvMjIgMDI6NTcsIEZyaWVuZHkuU3VAc29ueS5jb20gd3JvdGU6DQo+
IGZpbGUgb3BlcmF0aW9uIGVuZ2luZXMgaGF2ZSBzaW1pbGFyIHN0cnVjdHVyZSwgaW1wbGVtZW50
IHRoZW0NCj4gaW4gb25lIGZpbGUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBmcmllbmR5LXN1IDxm
cmllbmR5LnN1QHNvbnkuY29tPg0KPiAtLS0NCjxzbmlwPg0KDQpIZWxsbyBGcmllbmRseSwgdGhp
cyBwYXRjaCBkb2VzIG5vdCBidWlsZCBzdWNjZXNzZnVsbHkgb24gTGludXg6DQoNCmh0dHBzOi8v
dXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2dpdGh1Yi5jb20vdmluY2VudGtmdS9maW8vYWN0
aW9ucy9ydW5zLzI3OTAxNTgyNzlfXzshIUptb1ppWkdCdjNSdktSU3ghX25UOWt5bVRyR1NZY1c4
UnJTM3R6Y0hhdEVnaXl4ZDc4WUJBblNvYjVuRzNFUDJ2Tms1UDQwWnpLa25xN050MFJIMmVQT283
U01qbW5IdnpWUSQgW2dpdGh1YlsuXWNvbV0NCg0KT24gV2luZG93cyBldmVyeXRoaW5nIHNlZW1z
IHRvIGJlIG9rOg0KDQpodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9jaS5hcHB2
ZXlvci5jb20vcHJvamVjdC92aW5jZW50a2Z1L2Zpby9idWlsZHMvNDQzNjI4NDVfXzshIUptb1pp
WkdCdjNSdktSU3ghX25UOWt5bVRyR1NZY1c4UnJTM3R6Y0hhdEVnaXl4ZDc4WUJBblNvYjVuRzNF
UDJ2Tms1UDQwWnpLa25xN050MFJIMmVQT283U01nRk1oN1VSdyQgW2NpWy5dYXBwdmV5b3JbLl1j
b21dDQoNClZpbmNlbnQNCg==
