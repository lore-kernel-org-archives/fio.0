Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E039C433EF
	for <fio@archiver.kernel.org>; Mon,  9 May 2022 14:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiEIOb5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 9 May 2022 10:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbiEIObm (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 May 2022 10:31:42 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2075.outbound.protection.outlook.com [40.107.21.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E722A76BB
        for <fio@vger.kernel.org>; Mon,  9 May 2022 07:27:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neZZWkCFqm1I+X38GvXSRxhfODhYtiK4JbUHwtTBJMBC9HGxVx5PikS2wIlwW/fd93zTlS6xpa3GhcBdTLhGp5L9LTpRsr5APyvouslP4LzZR15piAlXn2tRkJNtjzW/I7L2sJp/2hjMB4dtuUgjmht/jsQI4hzzbRB1ygQqpKTAsmG+HFKPkpsaTONARiO81a5qJDOPvXGK0P/dMK4tgq/0afj4m3u9mkdFTXUD5wc5j1FdzjBqgbnB+k3dP0aofqpb46T25Vvi+snNJVZw3lAIBglEv+TUWSBMaYNOORYw9fAnZqfaE+lzdfQC3zw/aR2rU6HtGW05dbtomXIMaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8sUqYmWvA0bnCEJ7PI8C4mzh+IPKp1JE5l37I7Srs4=;
 b=MDtvz6C6T8SLbnE6T2gbiAs2ImVivhJN/stG7gL9bScbebjWSd0J1taw5MvnPYSQLcg/ndCbhw+nNwHqx4Y7a0t2JwGkdlaJnK0+on/h03jyMWiez6Y6eJ9Vy6yRHM/miz/Urg4vbEjHrq1AaiKTOz6US/rqeEa/TrtYHHIApW0miPA0CyKcRSzCsV8VvkGjF90GUw/s3WnHBE3oc4wtGxiIHTnLfFzx/NmRrayNDBFGl7jPuDzUxPA1u0Nfa1fLD5fnvKUI2dEaf/tcM+waxB2AQgVlUDbDc9UREX34Jak1i2nVS0SzBvbJtAPO8RzOvo/nArKzY2T/tb0LAB2aHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mobileye.com; dmarc=pass action=none header.from=mobileye.com;
 dkim=pass header.d=mobileye.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mobileye.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8sUqYmWvA0bnCEJ7PI8C4mzh+IPKp1JE5l37I7Srs4=;
 b=j868GtN5Vi6N4BdvpNYvptaVMlCu/QOA2OXZYn9feNQDgVfWs/Fz9xfE+PiAswSukdd4Xm6pD+yKtEohUZhVF4BRABVeHINOcwP5XyuYq6EMIHsGjGf6gFY0H6FWvVLcjUKMWUNM7yYzp+OkanNMCmGWz4FNGI8fQ0C4MpYrhN0=
Received: from AS8PR09MB4663.eurprd09.prod.outlook.com (2603:10a6:20b:293::24)
 by DB8PR09MB3865.eurprd09.prod.outlook.com (2603:10a6:10:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 14:27:44 +0000
Received: from AS8PR09MB4663.eurprd09.prod.outlook.com
 ([fe80::150c:46df:6e3d:4f49]) by AS8PR09MB4663.eurprd09.prod.outlook.com
 ([fe80::150c:46df:6e3d:4f49%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 14:27:44 +0000
From:   Sagi Ahrac <Sagi.Ahrac@mobileye.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Weird results while reading from s3
Thread-Topic: Weird results while reading from s3
Thread-Index: Adhjr/6v+saKOVenQPiBuPuBVQsXEg==
Date:   Mon, 9 May 2022 14:27:44 +0000
Message-ID: <AS8PR09MB46631A5CACCCC66C7D067F8EE2C69@AS8PR09MB4663.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mobileye.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a46da08d-bd63-45f1-4a16-08da31c814e8
x-ms-traffictypediagnostic: DB8PR09MB3865:EE_
x-microsoft-antispam-prvs: <DB8PR09MB38657CA2507125FA2503FF0BE2C69@DB8PR09MB3865.eurprd09.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y7E3wpgkmsWg0uVycQpkyOKF5JGq5U9djdX/jbLhOFdwqyccR9eYpADocu2KL064837IJPGku/kLnXj3EpiomSJruvwP1Sxy4j1EeE2wPqsWJAZHO38J+g9yHqCCqWSmNIh3lQysqLYMbfHpzATsAzTT41OPqn3U3f6torEI8x4lRq2ZBEah4Uyyxmg0RqMRjpY686iWXAgolV1CgMh/BYAvVblvxAM3Zcyi0ZSo1BwbVbs0wIujuB3e/drb5nPY4iTQByplVKnBQaSpBV6/GVeImt228IEKd9sAyMOf7ym6oqt/p3vmC3qvOsn8FF/R3rTBDRvVxQl5TCKDw4FTYNKJSs9nvsMRpSgnbxOKy3//1NKtLCddUzf8HSMacG7e2IwUsPxg02R3JbMYB5FMTZJOt7ZvLRh2IYT+rvCX0fW0PeOZBfoKsh53VOFQJYaeKhXKuJ2Y9cRar9z0H9e7NnfOjYC914hTsmz78y7T0bIjWzTml/yYtaIrQhuchkPLHb+UDUjZgiYlkA2tORBk85n+d14svy6NxJ4VDM32y11TRsiItkgISlCV9A7EKeWcsrXs8EBJcUwiYEtSAbhDYu/UnYcmEAfnnLq3XFGrRp+95omrFADld3hQ5nTH4s61HHgiay3nWhgDlH4eUyLqrIl3pi3LwyC+w2fIr00WUIKRvpgvoQuLXmZRJ2F0JiHWSs3tfsNeffFycg34BoNBvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR09MB4663.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(7696005)(9686003)(6506007)(26005)(508600001)(186003)(6916009)(122000001)(82960400001)(86362001)(55016003)(64756008)(83380400001)(38070700005)(33656002)(5660300002)(52536014)(8936002)(66556008)(76116006)(2906002)(66946007)(66476007)(4744005)(316002)(8676002)(66446008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GTq2kt4+gdCuXAzTNgVNJzH8aW9gfjC/uChip4fVeXMQeuysDYXjQf+r140X?=
 =?us-ascii?Q?xShDG9SnCPgPlsMSUyOMC8M/eMFrrKZ4Ukz3k/adpyut7AaIbPr9qd/M52Yc?=
 =?us-ascii?Q?I9yb2eclppYX9MMq9oGO1kVUckti6RadTl78pm/ifN/EKnPg/Aal3wu9HQw2?=
 =?us-ascii?Q?YGvfhXnX2ITQf4NctgN5wXSdszoElgIkByv8UUmlMh1hqhfoxm/aoEP2Eo8+?=
 =?us-ascii?Q?LNo3199pytGgMSaDmY+lbdsqMARa2PFpWvXEiYRboJIpfG5MAE+gtUScUxIG?=
 =?us-ascii?Q?yUGcRn1c2hYn9iNOOF9E30myHKw9BBlm8EAoIgOiA0voQnJE7SFWmLW1H++e?=
 =?us-ascii?Q?zOfd1I1+7zbfk3Pv9SBOdS/LkKzDui9G0qi0j9Tltcdgpul56vwHLZI7Y/AP?=
 =?us-ascii?Q?ClpAoGVT/fUjExlcKgQE6byI8gFJnJfbvWpIjB281qHxID8m7DZ9msQw1n1S?=
 =?us-ascii?Q?SAGMpASGowC2zCXxYDL6PLn+qRChF+A1gCreCFsncnz4GEVqZ5Me1PtNbitB?=
 =?us-ascii?Q?1pyy62QmlWXVjtxUOiMHvKraFhqUZ1LEqvJpsx2aZn8DpqdSXm2M/Pj2IoXd?=
 =?us-ascii?Q?SCHwKvYQ8YW5aT/oNa5W56C1OaNeQRr3flM6uaMhv4RP4srm2Yy4PbvY4ORF?=
 =?us-ascii?Q?hS8kR0s0Qb81HtosxfPkbUMQcGUsVaYb8Hc93aOrIjxUBClnESF5jxpKxFRO?=
 =?us-ascii?Q?KSb59eORTCUGyZhUP3lF4RrtGCkui+gddTJA5O83Vh4Z0NwcFz58zdr1gX+t?=
 =?us-ascii?Q?CEwKLsJfdVKva5qlMTexztndrfII7Z419Z20iPx/WU+g3KM9bl2MKVRbi9wK?=
 =?us-ascii?Q?lOLYwSkNWzI6uab/0JkbMCiZqda4nx3ZqnD61wi0TdjBcd5zxnEHVcV4V5fy?=
 =?us-ascii?Q?D9r6nXClxVYzmIhLcun7oqWAqoPQ6BkJK51mIlFlv+2hiFvTCoQV7vio/i0m?=
 =?us-ascii?Q?0QHzzGtTIbL0l1kOVScoXKApluxwooXr8BbL5e9Gq/oHXJfXgDxO0DqJs8WM?=
 =?us-ascii?Q?2tERvQJHL9+cOagqkeSMK5g07RF1WSCSjMOn0EXv9JF7C8xxxkDKF6rDH1Ti?=
 =?us-ascii?Q?r0DM+1KFXZxp+TjwrT6WTwG3Olz932l2m/0aHuxGbduPt2iaG5GodkgcFpFM?=
 =?us-ascii?Q?/R7NsRsocx4LFyFDvQ1XJFE3bbH5GVRpOiM42SmsuAJVc03U+czIyXAWb2Af?=
 =?us-ascii?Q?ssQaNdiZGfDRxiwR/dYOmKqF5qWYlw1a0TxobNubyDqZQcyYPZl73ZCRSs+c?=
 =?us-ascii?Q?pbRBa/s3NoU9CpCpUdWC3hSuN2v2ch9QwfH98BKZHBPkTV1xJYlSVJq52Ipn?=
 =?us-ascii?Q?xV6VbLElkn2+iY6NU73KC55uN7EefKnXwtf7OtLPGze8uBnqSSSKHm7F5mgz?=
 =?us-ascii?Q?gBMyi1A3o5K8T4VfFBXZZoK5/WxVxl7IfTQ9NTbzbcT6GPDTYsfye/PFgjhP?=
 =?us-ascii?Q?14NZC43SladAr+yf2ksVLBHoquDv6+gSaiBzuAD4e05ntE9nMn9y1J/q+CO2?=
 =?us-ascii?Q?pgU+Jr0pYAOekLqENdnI6EvVbXVBKRA+3z83Y9P2STcyx2cEVCmIyXd7vX7F?=
 =?us-ascii?Q?xzU9Y/zFyyT7M5ZZsbcC3ZEwRrOuQbA23FyN91F6OC/+Hj7yxPdOgfqZss4g?=
 =?us-ascii?Q?ep1rRoRnJnCCei3eh1u6GPWdqsvmfO4AoMxcCzLMp7OBAlQR46X5FVE5Rc2c?=
 =?us-ascii?Q?C7bFNPuA4OAC5Dkg+Cjn5mtG8wCbE2nfIYiP/+5W8izBFLo69l3FsfsdpIfy?=
 =?us-ascii?Q?msq0V3w8Bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mobileye.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR09MB4663.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a46da08d-bd63-45f1-4a16-08da31c814e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 14:27:44.0178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4f85ba13-6953-46a6-9c5b-7599fd80e9aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G3oZHuQu+0wVVXcorT0fXvUCol9CU89NwuJZHN/EHR2dKG2t9T7LsLeq+R4uYr/lMHEBgC2hgLqEp0dWHWhtWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR09MB3865
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hey,
I'm not sure if it's an issue or just something went wrong in my job config=
uration.
While using fio to benchmark s3 bandwidth with different block sizes, I got=
 that with 500m+ block size I get more than 1gb/sec bw.
Trying to recreate these astonishing results using s3fs to read, I didn't e=
ven get close to fio results.
Is it an issue in fio, or something went wrong in my benchmarks?

These are the parameters served me in the fio job file:

[global]
ioengine=3Dhttp
http_host=3Ds3.us-east-1.amazonaws.com
http_mode=3Ds3
http_s3_key=3D${S3_SECRET_KEY}
http_s3_keyid=3D${S3_KEY_ID}
http_s3_region=3Dus-east-1
name=3Daws-test
filename=3D/mobileye-team-vd/idok/test_tv_parquet/20-03-31_17-08-46_Leo_Fro=
nt_0005.snappy.parquet
rw=3Dread
invalidate=3D1
randrepeat=3D0
direct=3D1
filesize=3D1300m
loops=3D10
numjobs=3D10

[test-1]
filename=3D/mobileye-team-vd/idok/test_tv_parquet/20-04-26_15-22-58_Leo_Fro=
nt_0097.snappy.parquet
bs=3D1000m
filesize=3D1300m



Thanks ahead for any help or advice!
Sage
