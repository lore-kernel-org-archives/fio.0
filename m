Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D4EC433F5
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 16:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B8761220
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 16:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhKDQg0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 Nov 2021 12:36:26 -0400
Received: from esa.hc4959-67.iphmx.com ([139.138.35.140]:8921 "EHLO
        esa.hc4959-67.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhKDQgZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Nov 2021 12:36:25 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 12:36:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1636043628; x=1667579628;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=qOCEZ5jiXXC7ItIvqbBrwkYceJ8lzb2e7m49IffCor4=;
  b=aqScmuADswDaBVJgZQZwpKO9qWC90HtVdjl+NKUTwe0jDbqVBTxx+r5U
   8kj5vQ2aY6uQrMesPdIyNpQ1K8fKsJnA/b0y+NKdl4HUv9UUnR6JzEIj/
   skv4ZAXBs4yj49TDrPHN3m/LbEGjU9+jx5pd4O85eDvHtAwkzidh5n3C4
   w=;
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 09:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaktlZdii6KOcU+Ej2lySVNe9x9sdZ6GD2vLWKfG5pxjASLuhDs05u1l5R2t9UeyYLa+4lAQ4Bu5ZukFXrYR4+oR8oE2G6YOUC3uRA/84zJjzP4WkLPldOXfdtWdWOj/9xJpzk7fS6z/gN01VUn46py1L+2jsr+HlmWxn++OebKJ/TnXaqec2yMh3Q+uLokCwqPNrqeeW+Uq17HXmpp6Hq0VYE3L5EZYCpop+YkK5I2na/U9r8wvVJZDUeIZvxeJQmrTT/Yqz5p5C7FOfIPXVzePVf0WkYVaIMlqik/PkEXf1/y+TZZ1CkqqUuvg/asxuRZZbmQsLxs1xZByBQDfYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOCEZ5jiXXC7ItIvqbBrwkYceJ8lzb2e7m49IffCor4=;
 b=Z05i5Om4EKHkrtxWM8TLiNDHITLwSqq2aaJ2EZj+s79az0je6Yi1xe3iIGhkBXEiSMnZLjzKcKFPEe6HBcPlmxXYMwzlpY0D1tgUrx1Jobf1XzL94v5F1LSziIXzOfOUbNG0SvFgGFpukz4kMH43LIjOfQEPPgfgOlR1m0fjVhEGBbnivx4RQpPOpMVNuyW3WSb1zkBok2jUajqwTRucYmOJX4Ug41J0hh3mh8fAp0j1gdt1fFQsQ6gEr7EId0yfQgaWjI+Ka7DPHn4Wv3KolFgfqSw8DXt1HOvGhjjgj+e5izbuokb/HpvT96XRmKqcDN202aRPe1wCWDSa3bNSpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seagate.com; dmarc=pass action=none header.from=seagate.com;
 dkim=pass header.d=seagate.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOCEZ5jiXXC7ItIvqbBrwkYceJ8lzb2e7m49IffCor4=;
 b=fqWiKme/fWs2bfu47FLj86o600G4a37dVJ16czz8I6/I28GQQnKnjcuof2Bk04Pc8ljo7GiVbFlK7qVPk62WjJn9o+Ta4GAPnKNXD/mGZTUdaKHm8Hk4YCVPoS2fXIz8Lsupgpls1ADM0w/OwyjLyuFRjRt5eHYPq0Y9Xou6GGY=
Received: from DM6PR20MB3300.namprd20.prod.outlook.com (2603:10b6:5:2ae::12)
 by DM6PR20MB2426.namprd20.prod.outlook.com (2603:10b6:5:1ae::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.19; Thu, 4 Nov
 2021 16:26:37 +0000
Received: from DM6PR20MB3300.namprd20.prod.outlook.com
 ([fe80::4c7a:5479:306a:7a5b]) by DM6PR20MB3300.namprd20.prod.outlook.com
 ([fe80::4c7a:5479:306a:7a5b%8]) with mapi id 15.20.4669.013; Thu, 4 Nov 2021
 16:26:37 +0000
From:   Phillip Chen <phillip.a.chen@seagate.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Any plans to support Command Duration Limit (CDL)?
Thread-Topic: Any plans to support Command Duration Limit (CDL)?
Thread-Index: AQHX0ZXRGTXLr4XGyE2iB64MnM5Bfg==
Date:   Thu, 4 Nov 2021 16:26:37 +0000
Message-ID: <DM6PR20MB3300AD21CEB20460F9893DE4DC8D9@DM6PR20MB3300.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Enabled=True;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_SiteId=d466216a-c643-434a-9c2e-057448c17cbe;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_SetDate=2021-11-04T16:26:37.319Z;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Name=Seagate
 Internal;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_ContentBits=0;MSIP_Label_56e366eb-86f1-4645-85a7-f29555b26fee_Method=Standard;
suggested_attachment_session_id: bc649e2e-10d6-cce6-0164-52725e4041ac
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=seagate.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c98645f3-b092-4c57-249e-08d99fafdff5
x-ms-traffictypediagnostic: DM6PR20MB2426:
x-microsoft-antispam-prvs: <DM6PR20MB242632863BC4FB3F83BEB4A7DC8D9@DM6PR20MB2426.namprd20.prod.outlook.com>
stx-hosted-ironport-oubound: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n2rm3/b+0Ft/9IUbfbzrXjs60YtC35HgpZ2X+XQpW1psdqe+1kkilBY43DSt/cqnTbuCKWe/QbosR/lvO9JCxlgWvBFd9I1OksCm2+L1l1IXb3zRztqQUvprxvxq4YyPMIBFHyVBUuETEkELxmzyhtH7f7PDj0wDvqkIWFAJwwsJm7CHANw9H0htWWARKtWO0wxWRgEUcbUVL7DwABLdq7LVyh4q5xH3xXZID5usaWYzUDIDDKjjR9K/sBOcsiQfPCGPokZ++yA11Y5WBlp9f4qSzmmnDuHPyamJXzJuK4ALuB+k0ebxGaC5ZkbaT/Er8kzkXNF7bNzLzJM1yTBYMHyDQqbQlRRhMtaGd5pechej/t31GU08JwBKinTsT1318KDJ7ifmCfuY1IaU14ajyqcRKlkalH9E++58vlReFY6Fimje/51XdLvW6TE2Dfw2VoIUmdI21bllkvsEHjrcBGpapSgmafWybWVRUKcVYn3Msy6bSlK2TdkrteQGCOE3CEtrHFA7SEzDPP9EeNvuKK9buPKQyRk1gsh/vtzV5ZmuyxsjTzVhqrq7FiZyZTjHyfWUZBsB+mKeW+trNeziDFSGITTAZJdBRsvk/pfJIbocMyVBHyrFDLb0BErrfXce/CcI3HLChaBEEAdfujo4fuZcOZVjZK2DgniZdgOzPWxAJV/kfIM/GupJYhNPEKbAYE7HwRwAORxKDWRzptd6jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR20MB3300.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66446008)(8676002)(66556008)(66946007)(2906002)(83380400001)(66476007)(64756008)(4744005)(6506007)(508600001)(52536014)(91956017)(5660300002)(71200400001)(8936002)(6916009)(33656002)(7696005)(55016002)(316002)(38100700002)(26005)(122000001)(38070700005)(9686003)(86362001)(186003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?M58cH3alzGFqn0AYMA98v2mtpTN5iIRGgMGEIePOtcG43TSn+DqDcJk82e?=
 =?iso-8859-1?Q?1S6pLKiK93zd/jD0s2sT586zsYBPDILVmeF1Bo9fr1JTgCtR8nU6oVOVjr?=
 =?iso-8859-1?Q?qVII4tQoo0j/ekwa+iAFx4NOxdLrCrlfnZ8NW4hOWiOlR6V7QZ8BEG3oxU?=
 =?iso-8859-1?Q?LWw7HXAGK1T2SVFm1uorLc5ZVrMYt0kP7+0uMiaUBExDc0KlgjSgPTyfpJ?=
 =?iso-8859-1?Q?CLSIsKrH8L62RXZp27VLYI5JAEZjLEB8x1q0urB3gXC1cm5ATW0Li1lPuh?=
 =?iso-8859-1?Q?IPl/UQdTw1DydJiHVoA4HyHSbpXOtWhlKbeqfuYsuGvSajWWN1BikMPVYm?=
 =?iso-8859-1?Q?5Yogvyint15++aJofwGKZ7wRqRfgA8wCM3lPR68yezTAnFtHxJIY2cJdZ1?=
 =?iso-8859-1?Q?2ui8+2flvG8jI9YLN2PAXzPwArw3Ljm4nx+odNyIRhDRE0G7R96fiZgXYp?=
 =?iso-8859-1?Q?jm5lu8h0nrx1LV9q73rn0vURa4YenAqUq2+1/oPvScp4sioYQV0oi9YiEF?=
 =?iso-8859-1?Q?X/hIRf+9lWgiQAj+sxqyl2gSZIp8mCL+1yThvMv60IQ3IqovCki8SPe5oz?=
 =?iso-8859-1?Q?UjmxwyQC2AkX3Y5ijzxcQWpKHjeuSQAr4YT1AQua+nIQ9fLcwJ+savUFgL?=
 =?iso-8859-1?Q?gi48Oc1OexIxrsGfqk1nFk14AdkkCWldXs5K+H4SyFuJ2dg2dyleKSEOeb?=
 =?iso-8859-1?Q?GG+qIsHpC2mo6PcaBs2JeJ+lwy92WTe0tJdWTdRlLBQ2MxNGfp1ruVQmlg?=
 =?iso-8859-1?Q?urpn5+WD/LjcglNbVRb0fHek1DYuOC//EPICq0USPuCXEXuUe0RNL7GhuO?=
 =?iso-8859-1?Q?SGvIk1i34duc9wWxhEWwdctBtawmNyFyHm55lGse3tTf4SngLKx2MGI9w2?=
 =?iso-8859-1?Q?bOo7pEKU0QTUsTTetkjqMm9u/JhQnfEENWWiOY7swt9JeOr8mQbHNTQ/b3?=
 =?iso-8859-1?Q?/AgfIG51CqmxRhhc8ISui+vfZDAfCAfTvgcf0p9PDKXRjogQsO5Ev2Bbid?=
 =?iso-8859-1?Q?Cxy20oydODIKNtFEDwFSEe1tDlfcW48bRnnlZqAgyQoxMUe92fb/1lnk16?=
 =?iso-8859-1?Q?d4i0ftWIH6JoEXMlN5asW5Xam5qVwiBUaAWLctHB0E/NzHKsx3Ukx7+kg9?=
 =?iso-8859-1?Q?uHutaA/+zsxsuC60pVl8MWmX4KlmzFkqOFrSTsdFw8AXk6FQt70JNRrdPW?=
 =?iso-8859-1?Q?JwdJG7wxmr6qf6aZbb1CANcDOT8Y+UksX1n5xDDGy1Ih9ze9NCN4NOKcG8?=
 =?iso-8859-1?Q?YHY9atV8s0uy/OOD8uEnvfT223iqaIl9egODqo+8B5dK0vMLq+qGx8TCxm?=
 =?iso-8859-1?Q?lzXfYyfIiz5nKKikliAbilIARMjpkcncTffQLCfMDZYkloJMqIwhSIT4uh?=
 =?iso-8859-1?Q?1iPP2A4dawje1nfvzKja5RVgBbsLNL7XaKlwkKz7DofA56PTHy3JgBSd9+?=
 =?iso-8859-1?Q?P7KN98HpZVZCy6oSSSrIRBUqu1Yrm6RK7E1ba1IPqh9ClNPeVPaEUxTWnQ?=
 =?iso-8859-1?Q?ZTkRhJOxOVydRK/qnskz6Z9nC+M/qgmNT7VXvntjWnxqAfCkIm9bL32FfQ?=
 =?iso-8859-1?Q?N37VaqKQca8fwk3YSQXmz/lkQ7CgcsVDiqzm1X8c2ASQYlqFzW0FFGMnoH?=
 =?iso-8859-1?Q?BeECKU2DpEqBVcVf+eGdYKlg9ELl61CAWAaeowFUiPkIzf2OqJ8tYDmkgo?=
 =?iso-8859-1?Q?PltnGNc9efsEXbOtRv4B0FZjMpPS2+xydnJQIEZjxaphku0VDJWle2gfvC?=
 =?iso-8859-1?Q?/WHw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR20MB3300.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c98645f3-b092-4c57-249e-08d99fafdff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 16:26:37.3052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bM8JxiiWSFWqdc2vTwQlMaHeBkOI532fIii9WHbhRrFKOdZQqA7vY9DhR8gMoyjNEOnhuYfMupecqPrfAMKysrcz3wxIUyqaBhv2sQI8vh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR20MB2426
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello all,
I've been hearing about the command duration limit feature (4.7 in the ACS-=
5 revision 8 and 5.2 in SPC-6 revision 1) as a more flexible and powerful a=
lternative to priority commands. Does anyone have any plans to make this fe=
ature compatible with FIO? I imagine it would take quite a bit of work to e=
ven make CDL accessible to FIO, but I'm just curious is anyone making the e=
ffort?
Thanks,
Phillip Chen

Seagate Internal
