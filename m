Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33045 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbeCQKBD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Mar 2018 06:01:03 -0400
Received: by mail-ua0-f172.google.com with SMTP id f6so8155531ual.0
        for <fio@vger.kernel.org>; Sat, 17 Mar 2018 03:01:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB111655928AE4688373702CEB81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB11163E6C999998E0A2F13F9E81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB111689EE46B3839EB0675D7B81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhHoS62hDsz9cvwjYBJFODDZ6EvTry9u4nErXAC67JwKg@mail.gmail.com>
 <CY1PR0401MB111673C9DC353353BACFCE5B81F50@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116FC09283C22316161F3E381CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgi-muVZ4XVF53amSHOzLjMEDSY2Z2GRmKso_VZ1sVazA@mail.gmail.com>
 <CY1PR0401MB11163A5F0CE792CC28A7252D81CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxiso_3xAjP1CJ91=qXcsyKcwzN2XfBeGLvPzeMj45BLGQ@mail.gmail.com>
 <CY1PR0401MB111641A66DF1AC0E016E97E181CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjmz4t_rbXuDwqPmiAPXUg_h88qvcRUGbXPCRAnDcw8Qg@mail.gmail.com>
 <CY1PR0401MB1116F8AD0CBB303383918EA481C10@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxg0pNhmSnvRGDL7um-KhX8eqwHfk1T8CSaQYih2c8p33Q@mail.gmail.com> <CY1PR0401MB111655928AE4688373702CEB81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Mar 2018 10:00:31 +0000
Message-ID: <CALjAwxgtTM--wW-NwkDe_5RWGeZQ=FUQUH_HXK8hOsci5pDpxA@mail.gmail.com>
Subject: Re: fiologparser_hist.py script patch and enhancements?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

Hi,

On 15 March 2018 at 17:02, Kris Davis <Kris.Davis@wdc.com> wrote:
> Sorry I've been unavailable for a couple of weeks.
>
> Chose #2:
> 2. Keep one script but somehow let it contain non-weighted vs weighted pa=
ths.
>
> I merged the changes from my "no weighted" version with the original scri=
pt, and added a "--noweight" option.    I didn't try to combined the file i=
/o methods, but just split the "main" function latter operation into "outpu=
t_interval_data" and "output_weighted_interval_data", for lack of more crea=
tive names :).
>
> Below is the new patch

By some chance you wouldn't have this up in a github repo too? GMail's
web client seems to do unspeakable whitespace changes to patches (I
wound up copying and pasting from
https://www.spinics.net/lists/fio/msg06872.html in the end). I still
get grumbles about trailing whitespace from git but again I don't know
if that's just how I got the patch.

Could you update the tool's manpage
(tools/hist/fiologparser_hist.py.1) with your changes too?

Shouldn't __HIST_COLUMNS be changed depending on whether micro or
nanoseconds are being used? It looks like it matches FIO_IO_U_PLAT_NR
which is calculated by (1 << FIO_IO_U_PLAT_BITS) *
FIO_IO_U_PLAT_GROUP_NR which for fio-3.5 is (1 << 6) * 29  =3D 1856 .
Commit https://github.com/axboe/fio/commit/d6bb626ef37d3905221ade2887b42271=
7a07af09
seems to be the one that changed the value of FIO_IO_U_PLAT_GROUP_NR
...

Beyond that a simple run worked for me with the following:

cd /tmp/
fio --name=3Dtest --rw=3Dread --runtime=3D5s --time_based
--filename=3D/tmp/fio.tmp --size=3D1M --write_hist_log=3Dtest
--log_hist_msec=3D100
fiologparser_hist.py test_clat_hist.1.log
fiologparser_hist.py --noweight --percentiles 0,1,50 test_clat_hist.1.log

--=20
Sitsofe | http://sucs.org/~sits/
