Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-by2nam03on0073.outbound.protection.outlook.com ([104.47.42.73]:15904
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751283AbdBWUzc (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 Feb 2017 15:55:32 -0500
From: Chris Taylor <ctaylor@pivot3.com>
Subject: FIO  log averaging issue with --write_bw_log and --write_iops_log
 using > 1000 log_avg_msec values
Date: Thu, 23 Feb 2017 20:55:25 +0000
Message-ID: <CY4PR10MB1494804E84709ACA355AE6AE8C530@CY4PR10MB1494.namprd10.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

There is an issue in FIO when using the detailed bandwidth and iops logging=
 with averaging over a period of time > 1 second.
It seems that usecs overflows which later causes negative time diff values =
resulting in skewed toward 0 results.
I have attached a potential fix that should prevent usecs from going beyond=
 1000000.

diff --git a/time.c b/time.c
index f5dc049..c748bee 100644
--- a/time.c
+++ b/time.c
@@ -8,11 +8,18 @@ static unsigned long ns_granularity;

void timeval_add_msec(struct timeval *tv, unsigned int msec)
{
-=A0=A0=A0=A0=A0=A0 tv->tv_usec +=3D 1000 * msec;
-=A0=A0=A0=A0=A0=A0 if (tv->tv_usec >=3D 1000000) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tv->tv_usec -=3D 1000000;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tv->tv_sec++;
-=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0 int adj_usec =3D 1000 * msec;
+=A0=A0=A0=A0=A0=A0 int adj_sec =3D 0;
+=A0=A0=A0=A0=A0=A0 tv->tv_usec +=3D=A0 adj_usec;
+=A0=A0=A0=A0=A0=A0 if (adj_usec >=3D 1000000) {
+=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0adj_sec =3D adj_usec / 1000000;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tv->tv_usec -=3D=A0 adj_sec * 1=
000000;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tv->tv_sec +=3D adj_sec;
+=A0=A0=A0 }
+=A0=A0=A0 if (tv->tv_usec >=3D 1000000){
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tv->tv_usec -=3D 1000000;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tv->tv_sec++;
+=A0=A0=A0 }
}

/*

