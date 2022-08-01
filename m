Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCD5C00144
	for <fio@archiver.kernel.org>; Mon,  1 Aug 2022 06:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHAG7L (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 1 Aug 2022 02:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHAG7J (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 1 Aug 2022 02:59:09 -0400
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8A32558C
        for <fio@vger.kernel.org>; Sun, 31 Jul 2022 23:59:05 -0700 (PDT)
Received: from pps.filterd (m0209318.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2714MMf5001175;
        Mon, 1 Aug 2022 06:59:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=3iYAtYonBJrrwH/TavoMFfzexsNs58NUM5H4KsKlano=;
 b=e/JxZTsIIEdsQNlU3UZRsAZTyK0DbhYREsmQxNJxVIKe4L07A0quYkNC+rmEaZdF7IL6
 skv6GmPd+TpUQsUVeE1AGTVGeL88pqzPt7ej5Uwk4yVyqr3qp2qONZseE8JbSZQvSodn
 Ctl2hEHJqVea4xRVJi6+kh4IS9vlArUE6Bxa0TUyi7pJYdQntC5TbascVBB9IZtPzO74
 tv3xCYSGH3R1xkzW+zGxZm3YAR9nWeDAGLGFHrdzFIEeFrc4MQVIsr9/AA2tSHiNfFZ7
 idgUgQ1PfzCnKOrm6rGA/p4nyjznVbn9WrDnAdkfAufsAW+FF6lp7m+y2C8By670RukR iw== 
Received: from apc01-tyz-obe.outbound.protection.outlook.com (mail-tyzapc01lp2048.outbound.protection.outlook.com [104.47.110.48])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3hmu75shrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 06:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ClkEfOhEWTvJZonzbyRuVrPUJ2fVYeRrekoo/Bt5R3uPvTYaCTB66wZj7oJeTDXKRBcfsYjbCEUnRKAI+hGkut+50i8dqX+RS8a3Mte+CHmRREy5a2iz6SpwVsQCMTpwCDQX7ILpeUKbncWLRlnPXnFHCN/Vt9SjDwSScJHF9RP57MDRBatZgRi1e2P8Rw67rEhODodAy/qMOPvVghRRAUrymq1VShPF8isXH3Ptxc8Y4+3x+WYHs+BbHGUmRNFhCUw+fjtjVzy5yMW3cbMx2cxMIKI9uho7Jlhx9jN+6m9N7gJ5m4POuhuKRe0L43/sKZN8ds8xt9ouQiLFWwreTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iYAtYonBJrrwH/TavoMFfzexsNs58NUM5H4KsKlano=;
 b=Lv9q58K395qYMmNMItr9L2lSKgaNEBCMBwriiZ9kdZb96/eFO4YPRWGPIl0LF2J521WQgMn+BknXbFzaibS4Z0PF1EJrk2PuqBX+/mBkxB6JkpFchUx4ogXc9QQQjWfZjKuQ0ehnQkvBjgic2YltihvfFaIOUPpLZob61DSrJYndjBqqCPwVbyDxBQWTvOKNIFut1Wl5grxxSgQSDaQwZXcm110/9TYlw8slqdX3fzY1Bjzr7BitI7zZhNNfEJLatJpEjA+PIyeKHjo3atsML8HZBw4d0wXcvHE04nJA7q+Xrgr8293O1KI3ELssHXjxXXcJi3PrTvhesdOg4z10DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com (2603:1096:203:44::12)
 by PU1PR04MB2504.apcprd04.prod.outlook.com (2603:1096:803:38::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Mon, 1 Aug
 2022 06:58:56 +0000
Received: from HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::ad41:9b0c:99d:76f8]) by HK0PR04MB2388.apcprd04.prod.outlook.com
 ([fe80::ad41:9b0c:99d:76f8%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 06:58:56 +0000
From:   "Friendy.Su@sony.com" <Friendy.Su@sony.com>
To:     Vincent Fu <vincentfu@gmail.com>, fio <fio@vger.kernel.org>
CC:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
Subject: RE: [PATCH] engines: add engine for directory create
Thread-Topic: [PATCH] engines: add engine for directory create
Thread-Index: Adh9Zadb9x5EFX0pQZqAz8T1ID5MagdM0biAArbEtQA=
Date:   Mon, 1 Aug 2022 06:58:55 +0000
Message-ID: <HK0PR04MB23888F561D44A542D9E6115AFD9A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
References: <HK0PR04MB23884338D98BC24EB547AB9BFDA99@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <79535fa5-66c4-d7df-73f8-a128e9b4150b@gmail.com>
In-Reply-To: <79535fa5-66c4-d7df-73f8-a128e9b4150b@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b6889e9-f219-41d1-b02a-08da738b4d49
x-ms-traffictypediagnostic: PU1PR04MB2504:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yZIypxTqLB8n+Er4+fL1EdVP3AgPhpXeDW8ImiAyeyF5r6jVeztYKUrZN6KtmcKO4f/+2O6xzwn1j+BCdiI/n3u+FQLN/jEriA1fA4Vc/lEu9LRZ7oYO+SBFVbDpGCz1n6qDwlP6bxvRoQWIXTXhSa+zIFA0/xpwUVYY2tpq+NWkolQDc594S6nwY0qdWkQy+u7zf3i87iO37cmadP9Vo4QCx3hoICHdFs15g3ho8w738KQIqp5fRHrhTfGuBIlSY0zvKNoEl/bK3h/MTqJzNo/ZYHYpyrX59KXElKM0y2/S0o5TIsInF7dgM6J8cqNCG9Y2GcP4/Zw9NcwDX6AVGJ18rlBYHOHgAGwurzlqP7AKuspyneoKi39qOKAfF5dGvlc3166YSPhA6FzrMB5DwFNcRRkpxqNBpV50mnMXpUSoE64+WBgSp69UBVTpW4bJPjWJ0SHJ6V3ZJXPRK07z6/BSrB47rRFUNnixLsSWrgd/lm677B0fjGNHs6wf6xt5RQ18MQyT6NyPVkxehwPkgikT0/Fd/H6LFx6iPIv34jKJGl1yTnF5lhk2oH+e81g0H3rO9ZmCeUZNqMXMr8/R59NUF2015gG8DOss4Ttwuxg3uTw7ZKuK9O18loS3VzHK3LAJRycdY4fGOoA6k2YYRv4jN7d63PsuVTCCSYkRgjHJ83Un7B0VtxEVIBSarpnrM39WeMQ0s3Cc507EItepuCUT49sqEJ3ApKmW4vUR0bKcYVVxv68DZjkHRXkBB8NjqBQpbktPg/g3445/a7Az1Ug3MtEb2+3YZEvvipbn8tY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB2388.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(66446008)(64756008)(66476007)(8676002)(76116006)(66946007)(71200400001)(66556008)(26005)(41300700001)(2906002)(52536014)(86362001)(478600001)(5660300002)(4744005)(8936002)(9686003)(6506007)(83380400001)(7696005)(53546011)(33656002)(122000001)(4326008)(38100700002)(316002)(38070700005)(55016003)(110136005)(186003)(107886003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHRRN3Btc1pFVndDMzhjZVI1cTY4bVB2MklGWVNrK2hBdkdCVks0UWRONHRN?=
 =?utf-8?B?N2QrdWp5Y3ArMWptZCswQVUwMG1MWnFuZzl5ZW5ack9ITlpML09QZWQ1b05i?=
 =?utf-8?B?TTZWQzFSMjJSWDhTWlBqQmc3THFzdytPL01pR0lxRmtpVFZQTzFWQWhjN2Q0?=
 =?utf-8?B?YVZDdFV1VXBkQ2YrY3BmL3VudmJoUjN0djgwYzBKcytReXhVeXNIMEpsdE12?=
 =?utf-8?B?WUZEWk5peTBHeEp2YmVpM3NoSW1IU0Q0RW5sdWkzanJRRENKaURPTER4dzEx?=
 =?utf-8?B?c0RjTENrb3ExSHZHaENwRkQ4ODI5bUJtNWVQS3RHM0hkSWN2WTNlUmJNYXlx?=
 =?utf-8?B?MmhydWpIa1BxeE02blg5Nkp6YkpFRzlWd3puSmRUN2dhbUN2R3c3akYzTHJ3?=
 =?utf-8?B?bDRON2RDTko1emRJMnJncUZ1bjJySVNtZ3FabU1tblhRbUFhWk9sME82anVN?=
 =?utf-8?B?QzZ6WmNlZlpOVGlTMEZVSElXdklSTlFtSXBvK1dDMWE4KzZNM1BqTDgxdDJ1?=
 =?utf-8?B?MUVjMVYvRnRORURreWdxOTZkd2g3Um9FWTVmRGJjQTYvaWFGaGxTbHlQWkFZ?=
 =?utf-8?B?S0pPd1BIdVp1M2pTOUpsa2lQeW5JWWRoaHY1VkxYTEhWckVZY1ZDMVpFeW8x?=
 =?utf-8?B?M1IvREFUTHliTzJlWW9iSmhqT0cwNnBKbmtHejIyazA0cGpOcUZkLyt1a29T?=
 =?utf-8?B?MHJPeW9TbFdFcGVLVkg3SEhlRzd6MHVCcEgrZmI5T2EzRVhOZ1hFUmZvOXV4?=
 =?utf-8?B?U0dWclFKNG8xM2VPSWF5ZHEwMWwzWkd4bEJ1Y2hqNWFmQ3J1am9zdGFIWm11?=
 =?utf-8?B?bFF5WXp3VWZuQldiQnN4WVFDakVXZzhnbGVwYk9GM2xHd2M4dXFzNWR5cG5F?=
 =?utf-8?B?eXNHYUFKTjdXTXNuRXhKQUQxQUZHL2Q4bVBPcUdWTXBMaFl3WGUvR0dobXU2?=
 =?utf-8?B?Yjl3RllYV29KSUdrTDZjcUdvTnVUbTJsQXdvN2VkV0lVbGdPR2JqYk1mYlhL?=
 =?utf-8?B?WTZtcFhrUWJ5RVY3enJXaUV3NzFmMTU3YTJ5d05pcWtwKzBJaTVVS3VrdWlv?=
 =?utf-8?B?clNRY2lZbGNJcW9ERXEvT3YzNXFzMS91dXVRc0lxWnk3bDFtZGpZekNWNUVN?=
 =?utf-8?B?MzZsV1c0WGh0cmZwbHdOUU9xMDdUbU1qZ1dJZnM3aTI3QjRRdHZYM3Y5bklY?=
 =?utf-8?B?UXB3YXNNVzRtb1VjVGhpWU5YSDRPYU5kNVBqNzd6TzM2Zm5WSWkxUEFsT0RT?=
 =?utf-8?B?TWExYUNDL3NGWU9QNWZhN0VTalBBS3FseUZHK0dOWW44V3RmUHphMWpUUXhi?=
 =?utf-8?B?UlFycXZkYloyWWdTaVp3Sjd4UnlkcDhJR0FqQmJrN1J0cUoxTzBJOUQ1RUR4?=
 =?utf-8?B?R2t1WHI1dVdPa1lFUkI1Lzl5S2ZFV3FOTFMwaXFITzZpb2R5RlBMZ0dHV3Nh?=
 =?utf-8?B?TE1MS0ZwajIzcDA2MDVPNElNbHZmQkpNbm45MnVNM0prN2t5dVA4eUxlRVg1?=
 =?utf-8?B?Q3FwUkxUNEhETlJ3MHJ0QUZDalFjN2J2YktEbDFPTGpJbURsa3dLWEIvTDBi?=
 =?utf-8?B?MjZEb3lqcmgyZ0xFRm40U2RIaWNFTjVXU0dha0t3TGFyMWp3M2xyNCtUWSt3?=
 =?utf-8?B?YURidXdUTkcrR0xCVzE0NzRtd0RCVkxBY2ZZUEQ3a3BVZ3RwU05UOWRXOC9L?=
 =?utf-8?B?a3ZRV1RtVzh1eG1RM1VpaDgrNTVKWEsvTGlVbHhXVzhNWkpoZThkNEVyaGt4?=
 =?utf-8?B?VkhzSFZvb3FtUG9FWkFxeFJMNXZIVVlzbUd2d2xLNnBFL2VWdUYwWXczTExQ?=
 =?utf-8?B?dGg2RGhUcXRrV254dzlFbEErRXJVRjlQZ2xOVlNVeUIrM3k1QWZmdmE3N3pv?=
 =?utf-8?B?SnVkUmdHaVNUSTJBTFRqY1ZyeU9CWC9meFE4bUluRWFyb0cvb1dlTXVEenJV?=
 =?utf-8?B?Rzh0OG5laldzMHpjeElLTXZkQlVyNWtrS25OUnNneXJKSjk4ZFUxUzE4Nlph?=
 =?utf-8?B?VGhhcXBJamhhaUFncEFPbWZWTFk4ZzFjSUd4M0lsTU9kRkZ3ZnFEbm5UZlVh?=
 =?utf-8?B?b25tKzBBRjB1RW5hdmVXbWVCNmMxKzVDN21jbHVHeVBuK3ZTRWlwcXJQS3dJ?=
 =?utf-8?Q?uJYIHfkBIxZuoXI+7TfD9fMlq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB2388.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6889e9-f219-41d1-b02a-08da738b4d49
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 06:58:56.0044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LdQ7AsgLo2FqzZXyzUpgsy/DXhRRuqmG+6O0WW1pjNM70SnAhMUJa9omQaORQ+Rp8IgO+C3E2L5nA1/1IPGnKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR04MB2504
X-Proofpoint-ORIG-GUID: n7tjM6ykQYQpXPTH6XU9qzqHpLaQN0E_
X-Proofpoint-GUID: n7tjM6ykQYQpXPTH6XU9qzqHpLaQN0E_
X-Sony-Outbound-GUID: n7tjM6ykQYQpXPTH6XU9qzqHpLaQN0E_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_02,2022-07-28_02,2022-06-22_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

VGhhbmtzIGZvciBjb21tZW50Lg0KDQpJIG1lcmdlZCBmaWxlY3JlYXRlLCBmaWxlc3RhdCwgZmls
ZWRlbGVsZXRlIGVuZ2luZXMgdG8gZmlsZW9wZXJhdGlvbnMuYy4gVGhlIHBhdGNoIGhhcyBiZWVu
IGlzc3VlZCBpbiBhbm90aGVyIHRocmVhZC4NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
CkZyb206IFZpbmNlbnQgRnUgPHZpbmNlbnRmdUBnbWFpbC5jb20+IA0KU2VudDogTW9uZGF5LCBK
dWx5IDE4LCAyMDIyIDc6MjQgUE0NClRvOiBTdSwgRnJpZW5keSA8RnJpZW5keS5TdUBzb255LmNv
bT47IGZpbyA8ZmlvQHZnZXIua2VybmVsLm9yZz4NCkNjOiBBb3lhbWEsIFdhdGFydSAoU0dDKSA8
V2F0YXJ1LkFveWFtYUBzb255LmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0hdIGVuZ2luZXM6IGFk
ZCBlbmdpbmUgZm9yIGRpcmVjdG9yeSBjcmVhdGUNCg0KT24gNi8xMS8yMiAwMzozNCwgRnJpZW5k
eS5TdUBzb255LmNvbSB3cm90ZToNCj4gDQo+IFRoaXMgZW5naW5lIGlzIHRvIG1lYXN1cmUgcGVy
Zm9ybWFuY2Ugb2YgY3JlYXRpbmcgZGlyZWN0b3JpZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBm
cmllbmR5LXN1IDxmcmllbmR5LnN1QHNvbnkuY29tPg0KDQpUaGlzIGFsbCBzZWVtcyBmaW5lLiBN
eSBtYWluIHN1Z2dlc3Rpb24gaXMgdGhhdCB0aGVyZSBzZWVtIHRvIGJlIHNldmVyYWwgDQpvZiB0
aGVzZSBmaWxlIG9wZXJhdGlvbiBpb2VuZ2luZXMuIEl0IHNlZW1zIGxpa2Ugd2UgY291bGQgZWxp
bWluYXRlIA0KZHVwbGljYXRlZCBjb2RlIGFuZCBtYWtlIHRoZSBjb2RlYmFzZSBlYXNpZXIgdG8g
bWFpbnRhaW4gYnkgDQpjb25zb2xpZGF0aW5nIHRoZSBpb2VuZ2luZXMgKGZpbGVkZWxldGUsIGZp
bGVzdGF0LCBldGMpIHRoYXQgZm9sbG93IHRoaXMgDQpzaW1pbGFyIHN0cnVjdHVyZS4NCg0Kc3lu
Yy5jIGlzIGFuIGV4YW1wbGUgdGhhdCBpbXBsZW1lbnRzIHNldmVyYWwgaW9lbmdpbmVzLg0K
