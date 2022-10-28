Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297BAC38A02
	for <fio@archiver.kernel.org>; Fri, 28 Oct 2022 11:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJ1Lur (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJ1Luq (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Oct 2022 07:50:46 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9681905CD
        for <fio@vger.kernel.org>; Fri, 28 Oct 2022 04:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666957845; x=1698493845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qshlEiRsjyQZEkYoJkeiBlq6EaDmY7D20zLv/+DaqQU=;
  b=QVpYONa5hlpLi31R9/VSt5RUam0/0XLggRskY8OnpOVEIwA35fJP5wjD
   5F1UUl9stRpEEdYTE+fZNWjjOGXN3pAjct5hI3xxryrn45kFGoyQXvfRJ
   xQLGLKsEUCelQVsx8DbPf5Q6hAkn2wHvnrUFxEgDrX7oxLEhCQmG7L/K7
   NTpuiBFLFhy/070q2Vh4tgCfEz/obIMyAtT+qQFmLgYfma8ISAqEyBLAx
   YJ5aNcav2lbP7oUhfTZc5t/aqCWV5X9XlrK2Joz3zrnR8t3LBekWTYQZz
   opmUwx6ZFZOmM5qLSoVa1Y1PunRTb61DwWTx3kDljece4ZPS6SpH01b57
   g==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661788800"; 
   d="scan'208";a="215323653"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2022 19:50:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZINHh4+YACEFSdr7j8d+oSx+8D4mg4LNivwyywrp0YHOqrfmjbcOq+F6Zm0kXRiYW9TCI7o7hg8El1KRqE/A6ZXAyRYGaudv/iffstwMtERbnm/QPkqDhLqpR3JUjfmzViRgX7yvnRBEOgWxsjTFmOzySLJSJSecPDocwXYjvf01XXNaVz+MAt1sfeRF1S5y7xehfdlPM9zLAj0uN+BN/30WZN/74rq7qOvHDWFSt+px8yEBtFUmQEOgiB8njAvPoSjKsnCJHcABijITAoJFg3HtKIKrI7PbEqhc7v9irB0cxnljysQkbeJylmt3W8GfU2LgV+/jdDdhCL78AFgZFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qshlEiRsjyQZEkYoJkeiBlq6EaDmY7D20zLv/+DaqQU=;
 b=ATxZ3+MaqFLDCKZmOjBerRfA2uE+vjRR4IBoUUrLptizwmKHeZi2u5yr2DLWg6oADu3SzuTapSX+V6t90jtVTAuSY1tdTP8+2DcRIJsCpoRPRWnJll66iYOQmjomQXQXFtEjykJvmPe2SSeE+UqtMsvlhQfvLNi7ug5B2acgX2kIKR97cPXqtplCiQsd1AtuMXZIPY5HwAimBfA1LTTlY08jTY9C6XXze5tjnufuKgGvZt9TMth7uRcoXQ4pwmGNMZsA6+U6Wcw5QwVGIoL2Ov93SmPHzZg2MBJ13BkgoAWnABed9vykrUiRqi0wR2p8J5TTaIvKu/2eFiVWljPyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qshlEiRsjyQZEkYoJkeiBlq6EaDmY7D20zLv/+DaqQU=;
 b=Wth+lVIky95HYrDuzTK1x25xP5mqPG9Pnkfh6Ngcrre1uus1yJw+Kk8c67HQJBj/woe4Nb54A3Ohoyn+adAbJyiTpnWReL5WjX7SsLoGdx8VK77t01KCTJElniWeFzJW1lmNG9t3pt71SDIWhmGhgLcHykSYnoiu4u3yXfcjPUk=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MWHPR04MB0495.namprd04.prod.outlook.com (2603:10b6:300:73::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Fri, 28 Oct 2022 11:50:37 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 11:50:37 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "vincentfu@gmail.com" <vincentfu@gmail.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2 00/13] zbd: fix unaligned block size issue and verify
 issues
Thread-Topic: [PATCH v2 00/13] zbd: fix unaligned block size issue and verify
 issues
Thread-Index: AQHY6cmZ4otWUV5vP0KCo3wTFDQ3064jEaMAgAChxQA=
Date:   Fri, 28 Oct 2022 11:50:37 +0000
Message-ID: <20221028115036.36lyvovdrscjhvdr@shindev>
References: <20221027060139.952508-1-shinichiro.kawasaki@wdc.com>
 <efbddfbab88e4eb07e4c4ee33303d00a1a5be51a.camel@wdc.com>
In-Reply-To: <efbddfbab88e4eb07e4c4ee33303d00a1a5be51a.camel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MWHPR04MB0495:EE_
x-ms-office365-filtering-correlation-id: 360ad20f-11d4-445c-0046-08dab8daa11f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cu7FZcHm+djdoL7630g6b+IBMecFhHrONbjJ7BYlHp4ju9cJHEvmDnHqyrktbdPUWe+meSscp5TZpKG5iuWFxscFwtTWjClYqzCgxt2lk2yYPEh89YfvCPnNuBLaYkO0VcFPUe2DH5lsJoFxJCGoCiNU2XPGfKFjDtI+2Pj0Ms6Nsda1S6ZkJn25eaGbTKJZCCOY0SfdKI8yjcskTyeYw/5JqvKSraNFuThKXB6636XRXM3jpSi4nHsionc2ZhBTpjBULiG203OGJ13RmqwL7CjAOUvPmtMK6zmbdvgXuO3uRr1mhKgGUgGs4zRT0mnzKgPoW2uUvC+GLmXNSzsqvHk/oiHRBAJwJ9NmJtKqLKkOCzmSiG60x1M8fg3dQdHG8rcXXY3Tof20ZBcJGeyQALmE1b0BjANEdJvKR7YoItd0RWWzmXQ+cuhlhDCLhc/hq27ebPQ0bAp05CJojQR348//JzbC9b1MwHX6W8Zv8t5ECY49llUXDlZUH9hxKhUI+bNBRiEts+3mA+xhCpcqnF5z3cYsBvxspqd5UuC7GbN4QI+HY/YJz5lTnMxcH9LyHDezdS4Zluc5mLZ1UWCaIkl1gEt8EzgIlLQvnrJFz5UIYXvp0SqhRXjf2WNnqFmqyqG7cVz49g56HoIB5qH072smxmNwqB8TEYVArPDTJZsletDt1UVm1e/cXRz1WplnFGH5M4lnVOsMgeoDfKX8aMldtPoLKvNKmCbBRqRHbDmqSqWnTEcRoJp6hgReGwlnIGxJf147iQwBZ4e350x7Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(9686003)(478600001)(26005)(6512007)(6506007)(186003)(1076003)(83380400001)(2906002)(15650500001)(44832011)(33716001)(316002)(6636002)(54906003)(71200400001)(6486002)(91956017)(6862004)(8936002)(5660300002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(41300700001)(4744005)(86362001)(38100700002)(122000001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Lb0R2h9Q66TiVxFGU73X/+qEnJKtq7kf6fVoB1snDtD3UH9iFduVSZqfNO1J?=
 =?us-ascii?Q?xE7xIJXP9pFXsECOkD1DsA5l6E7cxuAHKHRW8Qo/Q6Vo+bTvrcefy09Shit4?=
 =?us-ascii?Q?lyB044hLBeUmDAICENgqXXAksbrONiWH76RgkTmQK6yahWRVLISmcScShl+g?=
 =?us-ascii?Q?Lo93pMLXcxe5EBMmgvgD2pQTM57+VzD0wcgPc2CIr4eKZD0wUw48TaCh15x1?=
 =?us-ascii?Q?J3vQxrPoZgJKbIEQ8GwgOgretd8EhbL6lTr8uNnzYGCIzQMYiZpvSe2Wd2ng?=
 =?us-ascii?Q?NCVxnQCKz/O4Wng8veTtiuQ+LldPUozBnaxQM18UZI2CbEMYWWFBY6TDyl6/?=
 =?us-ascii?Q?8ylzzhscssKXVTivgS+mQqNkn0FVyui78QfghgwtNvgwixrfEXfsyOFqIDRj?=
 =?us-ascii?Q?Y7113SCCisTQ0RA9rlbeQVgTndHUCdaMFOn490vv/kl/0czrDoZ/DluEEtMa?=
 =?us-ascii?Q?Rdb86kTfjLrx2dsnuM6zZS4F1I2sHZ9GbolyoKctF+NLdUM1VBqxedz4RCXw?=
 =?us-ascii?Q?tyiz8CbSFDgZnFVLimBy2DNyk1Oy5wL9/N9N/C9IHtnJy/V8mSKmuR7KcDG8?=
 =?us-ascii?Q?zBFttlL7FiYx50W6MR5AjPpaXrxXLSGahCl/6e1bUUIWwpS9Oxo87z47jv0X?=
 =?us-ascii?Q?vp8e9HE/NH2+usZpVLINL5OZugwNqbgeusbKvAkHqkKwqoMkokNrbOVfeJbq?=
 =?us-ascii?Q?PtPKev4ULp/bZUAFbMLk6hdcLL6dnjdzdtc+LVnQxSs6JKbdLkxRGWgqc1iS?=
 =?us-ascii?Q?m6XHCP5LzrG8qz6PjppTZJwZsiy7MoByXfJH0sGr+yR+dWxvhF+rKqbhgEOH?=
 =?us-ascii?Q?LvfH8toYE+vqXwKssSeL0NjFkMQxq7pRBt3L3xfDpUcaR9UqIeB8YBge4Hc1?=
 =?us-ascii?Q?q+SWODfALDQ91BaSR9de0K5CZb6xcBCX8752fIQ75dreUJ+MZOV25G++heO5?=
 =?us-ascii?Q?mxGFGp10hexT0vDLExrP0z8SwqIHNRMrj9VVZuObPoC08/jwSHX6jECXZNXd?=
 =?us-ascii?Q?ZHmjabszjze9NbqQVDCSv1k3QQXJCb85f06htnSY/WW9YQ12h12ANBowk8OV?=
 =?us-ascii?Q?xp5VXJROVaCwRSNZaZaRUUdI52N7fNTbxSTFOrgBXkN5bMR9XmjpXz8L76WN?=
 =?us-ascii?Q?Ywnru/sztc+fXF25lfccNumQKKgFTQvOu6bFKeNYl+T3PPGu9FGk0TG9rJRx?=
 =?us-ascii?Q?4CqJeW51ueSnTfU646jy2jX+zzXuyS/mNOa1Lm2qVHUFFXwp/MYcL4dbQYXd?=
 =?us-ascii?Q?r2TV9Gjj3Banv3Wbawk2hILQzvUcz37k37zZluvV/45fSLu5eq92wnJhHxiT?=
 =?us-ascii?Q?on5vjjCeGdXDj6/Rb/Wkr41RPSrXhs0cXIr+Z2+Kr+z2fK3pmDhQPavDyVrR?=
 =?us-ascii?Q?tBB5I/hKzXd6m5yk1SOS9yqGBIn0yVqSHv2tKNsVbyT2IioMientcihrMeJ+?=
 =?us-ascii?Q?KsdMOpnFwXekEOGGUxGcJRGm9PUC5qYQbVRTX3O40aOPgIJCO/HOe+isWLx0?=
 =?us-ascii?Q?2gLjXVNnTbsxa6dpZp1/0o7Rw/3CIDfZvqmTKugwtVTYK8IqhPK4BYkJpS1Y?=
 =?us-ascii?Q?RcaXPbGfijxQbGxEuGxTg2LrorTn5MOyxjYwd6iSj5s6GiRjD/GCbXG2pPor?=
 =?us-ascii?Q?TezngrdU94ClDkuY44tEpzY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5619494A1363D49A212E8D835BF7296@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360ad20f-11d4-445c-0046-08dab8daa11f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 11:50:37.1578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kzEi0JlG+emZj1qVkokl1YUNYx1GpAPrNFXS7zTyn5t4MCxBbqMJWK4+4YQj1H/AwcPZY5QbAH024N6baA+mv88nzwTm6PeFRYuFn9REXYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0495
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Oct 28, 2022 / 02:11, Dmitry Fomichev wrote:

...

> The following scripts were run to test this series:
>=20
> t/zbd/run-tests-against-nullb
> t/zbd/test-zbd-support against a WDC SMR SATA drive
> t/zbd/test-zbd-support against a WDC SMR SAS drive
> t/zbd/test-zbd-support against a WDC ZNS NVMe drive
> t/zbd/test-zbd-support on a VM against a null_blk device (bs=3D4K) create=
d on the
> host and virtualized via virtio-blk method (experimental).
>=20
> All the tests above are passing. There is one small commit message change=
 that I
> suggested in a separate email. With that, for the series,
>=20
> Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Thank you very much for the comprehensive tests. Will send out v3 with your
suggestion and tags.

--=20
Shin'ichiro Kawasaki=
