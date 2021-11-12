Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A812CC433FE
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E8E360F51
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhKLJ5c (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:32 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31590 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhKLJ5c (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710881; x=1668246881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2Gfl6nO9Q2rJGKHUmMKi9cdGp7zetOv5vgojmCef6lc=;
  b=VgWkUgCkleRKKb1ILg9WWCerY3LduCaZAEWvlLopXXVcahnzSwhNAdZU
   RrxbnmT3DSF9BDbUHjaNhGfkkKr/WwBye8L98m8O3madM3dPSgLc/Rx3V
   iynfnB7+bn8gms9wsqRA0PbVlNFdL5sKMadLXYJX5rPZfPrrURFxVUphx
   l4baAllCFI1E6sQcFgghf78MwtTAbAJvS+nChqR6OJCZ6Q3IEhQA77BD7
   5mOma7xrQiSkrcOTaMHXhSjo0VBugEKA/paSIrctzECx9rEnPhPeos9WF
   PKqEbcH+mEM+McoVCIIyzYdTaFIo32ii6pYhqlTzbtcEhLsKbVO5iVPU3
   g==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="289360576"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQTbFNTK59x54yqOJaxIn9b7JwcePd4yeTu9GkD/o9ETl7xr4D8OhYAZAbt1FHU9//PCkJDnDw8ciQhN51Ej6essytQs9WhF271PpW2/6YXNZT8ld+BGxjTSAxPfgVCzYpb3PHRcVG/37RtQgHXMDwLslm8IreHPsFWtvQodkGX9uAiH6MCYzAtfmshNJII0hQqigwb+O6+gIkY8IHxlY9IKj+PpkGTD57l0hgtZ9Hz5hXucxuAqrfTbTVavQhUBNPFHjiXNZci0pSVuaK2fMkyw5qluDRW5FFCZZTy70Bmefq3ySmIrsZU/7CQTp0UQakCQ+KG32VaipAJYFBaKYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PyUR7mpZYTUPFfJv1NVhi65fuFzYcjo4RuR9DHZqPo=;
 b=kKcwUYBMRrpuTK9wwnvhudhhqVhso4bXF5ut1Yt0hSJnUnXjLBLkD7NowbzG9KtjVOk2/5bNcNsvhKo7H4PZvyTuhiD/J0ESD1exeOF7UC0oIibhGr7lkhKxoubjkcEBJEebxXwWYO/IfMpd72ikp3UihDwbPUCG352zZZL7B8tji92/OVHyWta5A3MKZhvvkNR3LTKSsTXVv22yOSK3eFBVmyYItCW+7P+CR9GSuxuTsK1r5U4pMPiaGMqk2RDm2+C6coL8SVtfddEUNjAsYY7ICu7LOJuw+SHyjc1+VxkVlbHVu8bo2I5p4OXQ56mgL2TP/OJl4axKrP0v9pHfwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PyUR7mpZYTUPFfJv1NVhi65fuFzYcjo4RuR9DHZqPo=;
 b=jgmyIP7pdQpkC1kxPkeVo5/wZZFw0JtY+Gz0o/QGTM9Vj7oLy+Wi9ZokIyHv1f0LAxReAzU73Rz408anJ4Eeqn1+Wr3AJrzRL4BfEWqmVCgZR3ww74C9tqWpVksQGGqSz2bw6nc97YVm14HRL4K2kJvqRkO6ALmVxTiXICx3gaM=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:40 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:40 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 2/8] cmdprio: move cmdprio function definitions to a new
 cmdprio.c file
Thread-Topic: [PATCH v3 2/8] cmdprio: move cmdprio function definitions to a
 new cmdprio.c file
Thread-Index: AQHX16tPZ0jhBFOCG0Sw1B+g4NJqSA==
Date:   Fri, 12 Nov 2021 09:54:40 +0000
Message-ID: <20211112095428.158300-3-Niklas.Cassel@wdc.com>
References: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72307f02-3cf1-4989-fad3-08d9a5c2720d
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB74334EE58D74427C65099C1FF2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FvQRlJMhLz8/+T0UHElQ6aUFQ4iELnPqIUIJYzaRCVi9GwKzyZuw14mS1qclZyL3FuFnTSgCvTN7FJhkBsYNCtihFMrirpOGOPDHlbXOo5bOtHevOMeg5rk3pw5asH5xq5IIPpLATau/2TmIIDL9RbQnojDklcil0wPVciwNPI+XtCIqX1KMhfvA5amIorx0Hwhs097m2Y10u+w6jaSyuyqDKwmJmXqI6QSiTKaS+NydFx7Ga3pEeaduon8oHhPEgYg0Mp6cPZBoqAi/wqCvcwQP/+VEwvurX2mRPqDuEEgY48/GBhubXs8Cf5ND8TFhI03AMjDYVku2JKkKXdJSUD03FLl8WsXK4KyMIpmjEh/T4ghf3bGSy+uYNhKhD1MwxYTHq/IhXE/MQGVbYuP39Uoy+BPCNWGmf+7xIbRdebYxpI83iKeJA4n5pMj6/KMu6PtMvhfncxED1rjMuOOaTU6unLZrLs80uSkx/sOUjOPb/yWICl/LB3gz5wXxx7fbeHA6NwEMPoTHePPs799edMBjsz8V+5Quxl8L7slTwZMhcbnmfzbfktFt5eSLptCqfZRVo93KzxRf9zikINr+m+fhy/cYRSF6SF8NBnrACUFlEpnmHJL53OjDN3dGD0G582UYtIGy/sYXwN7EuP5kilg+Km5boiUKXSFSdEoMzhjq5GqGtY9AKu0T2CCE27T0Ni4d2eX+h/R2iAAjn5mHNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FDbNKwcsEoSM/yiqZO8i4r1mvhjTKTS4rRE9zuwjCOrehtCCuCqzRXUeg2?=
 =?iso-8859-1?Q?7fhNHvLo53RAlTg7/TxakTdyf+/tBsVM5/cR6egAUqf6WW6gNkXVvjw3Ht?=
 =?iso-8859-1?Q?3r/8sZoqZnK+N1z9PqfyxTEL+lLLu48+7mZ50y3CuzNxr6Q95ukAxLdR+I?=
 =?iso-8859-1?Q?pE8nMqdYa3MBciX1J7R+So7GPMgc0ZIbvPhHhEDeLRJzdo11SSUv+Ph39l?=
 =?iso-8859-1?Q?qv6BHBOpUHiLo09tNsdWX1WGWYn3dIErxCNIeZ9Uwx5ea2/8Ge3YlxKuIo?=
 =?iso-8859-1?Q?j3GR2ozQFDQMy2lOCfe/qQhbF6NZRnRgGqzOK6OqePUvDDCZcScmoNlR1A?=
 =?iso-8859-1?Q?2Ya8Y2nkgWQAN46mNtE/rDTxUjz8y7vMKSl9lVyYzHX7L86Cnig7tfjrYB?=
 =?iso-8859-1?Q?p/9CMqoP5VU+oGd9WrWETsMuZlPNR8BhciO4S9nyp01MkN/urtzlQVhVBU?=
 =?iso-8859-1?Q?c2GFdQ1eVjCxoQN+E4QD9/Hzv5ob3YKy8K0dkZxLQ8h1yvVufrYr8Hu3yR?=
 =?iso-8859-1?Q?aZ7AYpXHle7Ct8BnArATLher6d1cFAAt8jvw5agNhhx7HFprZrlVKG5+fw?=
 =?iso-8859-1?Q?aY7ElEREXqRU0Bu+DoJtDL8HHwITuzFDAtxoBABdp3nQA9WhesbIeM2trk?=
 =?iso-8859-1?Q?T+ZsX4qj6SuBp+pWTCJG2CfnUyA75QQ/9GMHvPjtKSCUH9aOAZjPlcQfB2?=
 =?iso-8859-1?Q?eURiR70D4DV6DmMhGvPPxd+fKMa7cgO8m2Kj4pP8qgY5DN5IczL2zKzJZF?=
 =?iso-8859-1?Q?jzRxKmg01Hb+Z3FZ4gvYuwZFjYtiOvqRlAfcAjQX7yS055M6SgPwFaCQmv?=
 =?iso-8859-1?Q?24vLAwtwl6H6FeBwXH0w0ceFSPihvWAgk2GKzsUhQqnNVBbEl3osIunSjX?=
 =?iso-8859-1?Q?Sm/M7GCQpE+nPWVw/am21H9CkZfTotkxSrec3GdLsvAMXYgB0DjRADEbU/?=
 =?iso-8859-1?Q?csWVHnl/PkXNvHQVrGOa3ZO2Q8uD33/pbhJay6KF++ufbtoEmcUEw0Sv0e?=
 =?iso-8859-1?Q?6PlH5/YvJD0xdKjCbMKNvEtU2e3hz3UIGesAvqWzbYpTYy5IA3z37xAdL1?=
 =?iso-8859-1?Q?5qXDGhXYeIyyk+uK/kMxCGXi8lAIiQESONQeOZvd9xsK9h+kG6Nv8PPxfI?=
 =?iso-8859-1?Q?cindPKzdqO9EDop0bOTNn3QZhgGHi4IUufI5gIpR8qh+dolcDWmhqYoryt?=
 =?iso-8859-1?Q?70/hxKDQE24HWrOTpOXPY9TAhP5HPAA6uQN5LmkXWdp3fU+kK1xK0PAhgh?=
 =?iso-8859-1?Q?aC51Cn7uchdQeXaGi3S+/feycFB5Rz8clRQjNAssJPweDE0qAAcXoZKfT2?=
 =?iso-8859-1?Q?MYnPh/u0/weHR3iC2zE5Ao2rI8LfgHy2yASPaFqLZ/tMxG56johqqv4Vfj?=
 =?iso-8859-1?Q?lsEsmC1DGMkhGWy+zhe3r9yjMguJHwwDAvHbC+NCsnB/e/+HCmUIfcyRBA?=
 =?iso-8859-1?Q?AbuTRgBITUzI3tBhDNEOU3x7PNXva3XD2agLdkhUStIKkQ+gBb4Ay8fpK/?=
 =?iso-8859-1?Q?faTy34cLooTw98caDjR3CiM36CQpgjwCNQPbex+TEzjMqY9L/9Dv4WU0gc?=
 =?iso-8859-1?Q?oe48J9BQ0UUF5ut8DigdUiQEP3J2WWmd/ohxf1hXtBU2f3nDz7IIAsLMMB?=
 =?iso-8859-1?Q?RQ/ZSTg8ldnRkYjZBMfmXtIS8RxthavROQ7eY6Aq7LTadNJInC27fjJnCc?=
 =?iso-8859-1?Q?wYBxZvWxRf04FYjBqX4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72307f02-3cf1-4989-fad3-08d9a5c2720d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:40.3989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N1WYpOJBn4b3oPDbkHnGVthcMNUSH1cQ0stObdsh1thVLTXDtCoTGAXs0Al0nA2PjWvltJvpi1vjiAGpIMeIFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Move cmdprio function definitions from the cmdprio.h header file to a new
cmdprio.c file, such that we can add new static functions to cmdprio.c.

A follow up patch will add new cmdprio functions which do not need to be
directly accessible by ioengines.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 Makefile          |   6 +++
 engines/cmdprio.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++
 engines/cmdprio.h | 127 ++------------------------------------------
 3 files changed, 141 insertions(+), 122 deletions(-)
 create mode 100644 engines/cmdprio.c

diff --git a/Makefile b/Makefile
index 4ae5a371..e9028dce 100644
--- a/Makefile
+++ b/Makefile
@@ -98,6 +98,7 @@ else ifdef CONFIG_32BIT
 endif
 ifdef CONFIG_LIBAIO
   libaio_SRCS =3D engines/libaio.c
+  cmdprio_SRCS =3D engines/cmdprio.c
   libaio_LIBS =3D -laio
   ENGINES +=3D libaio
 endif
@@ -225,6 +226,7 @@ endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE +=3D diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c
+  cmdprio_SRCS =3D engines/cmdprio.c
 ifdef CONFIG_HAS_BLKZONED
   SOURCE +=3D oslib/linux-blkzoned.c
 endif
@@ -281,6 +283,10 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   FIO_CFLAGS +=3D -DPSAPI_VERSION=3D1 -Ios/windows/posix/include -Wno-form=
at
 endif
=20
+ifdef cmdprio_SRCS
+  SOURCE +=3D $(cmdprio_SRCS)
+endif
+
 ifdef CONFIG_DYNAMIC_ENGINES
  DYNAMIC_ENGS :=3D $(ENGINES)
 define engine_template =3D
diff --git a/engines/cmdprio.c b/engines/cmdprio.c
new file mode 100644
index 00000000..f5b7342f
--- /dev/null
+++ b/engines/cmdprio.c
@@ -0,0 +1,130 @@
+/*
+ * IO priority handling helper functions common to the libaio and io_uring
+ * engines.
+ */
+
+#include "cmdprio.h"
+
+static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_ar=
g,
+				    enum fio_ddir ddir, char *str, bool data)
+{
+	struct cmdprio *cmdprio =3D cb_arg;
+	struct split split;
+	unsigned int i;
+
+	if (ddir =3D=3D DDIR_TRIM)
+		return 0;
+
+	memset(&split, 0, sizeof(split));
+
+	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
+		return 1;
+	if (!split.nr)
+		return 0;
+
+	cmdprio->bssplit_nr[ddir] =3D split.nr;
+	cmdprio->bssplit[ddir] =3D malloc(split.nr * sizeof(struct bssplit));
+	if (!cmdprio->bssplit[ddir])
+		return 1;
+
+	for (i =3D 0; i < split.nr; i++) {
+		cmdprio->bssplit[ddir][i].bs =3D split.val1[i];
+		if (split.val2[i] =3D=3D -1U) {
+			cmdprio->bssplit[ddir][i].perc =3D 0;
+		} else {
+			if (split.val2[i] > 100)
+				cmdprio->bssplit[ddir][i].perc =3D 100;
+			else
+				cmdprio->bssplit[ddir][i].perc =3D split.val2[i];
+		}
+	}
+
+	return 0;
+}
+
+int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
+			      struct cmdprio *cmdprio)
+{
+	char *str, *p;
+	int i, ret =3D 0;
+
+	p =3D str =3D strdup(input);
+
+	strip_blank_front(&str);
+	strip_blank_end(str);
+
+	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
+
+	if (parse_dryrun()) {
+		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+			free(cmdprio->bssplit[i]);
+			cmdprio->bssplit[i] =3D NULL;
+			cmdprio->bssplit_nr[i] =3D 0;
+		}
+	}
+
+	free(p);
+	return ret;
+}
+
+int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
+{
+	enum fio_ddir ddir =3D io_u->ddir;
+	unsigned int p =3D cmdprio->percentage[ddir];
+	int i;
+
+	/*
+	 * If cmdprio_percentage option was specified, then use that
+	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
+	 * on the IO size.
+	 */
+	if (p)
+		return p;
+
+	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
+		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
+			return cmdprio->bssplit[ddir][i].perc;
+	}
+
+	return 0;
+}
+
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     bool *has_cmdprio)
+{
+	struct thread_options *to =3D &td->o;
+	bool has_cmdprio_percentage =3D false;
+	bool has_cmdprio_bssplit =3D false;
+	int i;
+
+	/*
+	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
+	 * is not set, default to RT priority class.
+	 */
+	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+		if (cmdprio->percentage[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+			has_cmdprio_percentage =3D true;
+		}
+		if (cmdprio->bssplit_nr[i]) {
+			if (!cmdprio->class[i])
+				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
+			has_cmdprio_bssplit =3D true;
+		}
+	}
+
+	/*
+	 * Check for option conflicts
+	 */
+	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
+		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
+			"are mutually exclusive\n",
+			to->name);
+		return 1;
+	}
+
+	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
+
+	return 0;
+}
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 0edc4365..33a8f5b9 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -16,129 +16,12 @@ struct cmdprio {
 	struct bssplit *bssplit[DDIR_RWDIR_CNT];
 };
=20
-static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_ar=
g,
-				    enum fio_ddir ddir, char *str, bool data)
-{
-	struct cmdprio *cmdprio =3D cb_arg;
-	struct split split;
-	unsigned int i;
+int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
+			      struct cmdprio *cmdprio);
=20
-	if (ddir =3D=3D DDIR_TRIM)
-		return 0;
+int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
=20
-	memset(&split, 0, sizeof(split));
-
-	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
-		return 1;
-	if (!split.nr)
-		return 0;
-
-	cmdprio->bssplit_nr[ddir] =3D split.nr;
-	cmdprio->bssplit[ddir] =3D malloc(split.nr * sizeof(struct bssplit));
-	if (!cmdprio->bssplit[ddir])
-		return 1;
-
-	for (i =3D 0; i < split.nr; i++) {
-		cmdprio->bssplit[ddir][i].bs =3D split.val1[i];
-		if (split.val2[i] =3D=3D -1U) {
-			cmdprio->bssplit[ddir][i].perc =3D 0;
-		} else {
-			if (split.val2[i] > 100)
-				cmdprio->bssplit[ddir][i].perc =3D 100;
-			else
-				cmdprio->bssplit[ddir][i].perc =3D split.val2[i];
-		}
-	}
-
-	return 0;
-}
-
-static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *i=
nput,
-				     struct cmdprio *cmdprio)
-{
-	char *str, *p;
-	int i, ret =3D 0;
-
-	p =3D str =3D strdup(input);
-
-	strip_blank_front(&str);
-	strip_blank_end(str);
-
-	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
-
-	if (parse_dryrun()) {
-		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-			free(cmdprio->bssplit[i]);
-			cmdprio->bssplit[i] =3D NULL;
-			cmdprio->bssplit_nr[i] =3D 0;
-		}
-	}
-
-	free(p);
-	return ret;
-}
-
-static inline int fio_cmdprio_percentage(struct cmdprio *cmdprio,
-					 struct io_u *io_u)
-{
-	enum fio_ddir ddir =3D io_u->ddir;
-	unsigned int p =3D cmdprio->percentage[ddir];
-	int i;
-
-	/*
-	 * If cmdprio_percentage option was specified, then use that
-	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
-	 * on the IO size.
-	 */
-	if (p)
-		return p;
-
-	for (i =3D 0; i < cmdprio->bssplit_nr[ddir]; i++) {
-		if (cmdprio->bssplit[ddir][i].bs =3D=3D io_u->buflen)
-			return cmdprio->bssplit[ddir][i].perc;
-	}
-
-	return 0;
-}
-
-static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdpri=
o,
-			    bool *has_cmdprio)
-{
-	struct thread_options *to =3D &td->o;
-	bool has_cmdprio_percentage =3D false;
-	bool has_cmdprio_bssplit =3D false;
-	int i;
-
-	/*
-	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
-	 * is not set, default to RT priority class.
-	 */
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
-		if (cmdprio->percentage[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_percentage =3D true;
-		}
-		if (cmdprio->bssplit_nr[i]) {
-			if (!cmdprio->class[i])
-				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
-			has_cmdprio_bssplit =3D true;
-		}
-	}
-
-	/*
-	 * Check for option conflicts
-	 */
-	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
-		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
-			"are mutually exclusive\n",
-			to->name);
-		return 1;
-	}
-
-	*has_cmdprio =3D has_cmdprio_percentage || has_cmdprio_bssplit;
-
-	return 0;
-}
+int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
+		     bool *has_cmdprio);
=20
 #endif
--=20
2.33.1
