Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:20022 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdGZXqf (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Jul 2017 19:46:35 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: fio Windows Time
Date: Wed, 26 Jul 2017 23:45:46 +0000
Message-ID: <BN3PR0401MB145790BF6F19F8F52E278C908FB90@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,
When fio prints a summary output in Linux, the timestamp appears correct wi=
th the Linux system date/time.  However, on Windows, the time reported seem=
s to be incorrect (wrong time zone)?

    test_job: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1928: Tue Jul 25 21:=
24:23 2017

It looks like the fio timestamp is reported by stat.c, show_thread_status_n=
ormal():

    memset(time_buf, 0, sizeof(time_buf));
   =20
    time(&time_p);
    os_ctime_r((const time_t *) &time_p, time_buf, sizeof(time_buf));

    if (!ts->error) {
        log_buf(out, "%s: (groupid=3D%d, jobs=3D%d): err=3D%2d: pid=3D%d: %=
s",
            ts->name, ts->groupid, ts->members,
            ts->error, (int) ts->pid, time_buf);

Is there a better way to query system time on Windows platforms?  Thanks.

Regards,
Jeff

