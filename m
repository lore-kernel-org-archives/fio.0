Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50429 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbeCUAQb (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Mar 2018 20:16:31 -0400
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio server/client disconnect bug
Date: Wed, 21 Mar 2018 00:16:28 +0000
Message-ID: <SN6PR04MB4064CEF242E2091737402D268FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
In-Reply-To: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Revisiting this issue.  It seems the call stack is:

fio_handle_clients()
    fio_handle_client()
        case FIO_NET_CMD_TS:
            ops->thread_status(client, cmd);
            .thread_status    =3D handle_ts
                static void handle_ts(struct fio_client *client, struct fio=
_net_cmd *cmd)
                {
                    struct cmd_ts_pdu *p =3D (struct cmd_ts_pdu *) cmd->pay=
load;
                    struct flist_head *opt_list =3D NULL;
                    struct json_object *tsobj;

                    if (client->opt_lists && p->ts.thread_number <=3D clien=
t->jobs)
                        opt_list =3D &client->opt_lists[p->ts.thread_number=
 - 1];

                    tsobj =3D show_thread_status(&p->ts, &p->rs, opt_list, =
NULL);
                    client->did_stat =3D true;
                    if (tsobj) {
                        json_object_add_client_info(tsobj, client);
                        json_array_add_value_object(clients_array, tsobj);
                    }

                    if (sum_stat_clients <=3D 1)
                        return;

                    sum_thread_stats(&client_ts, &p->ts, sum_stat_nr =3D=3D=
 1);
                    sum_group_stats(&client_gs, &p->rs);

                    client_ts.members++;
                    client_ts.thread_number =3D p->ts.thread_number;
                    client_ts.groupid =3D p->ts.groupid;
                    client_ts.unified_rw_rep =3D p->ts.unified_rw_rep;
                    client_ts.sig_figs =3D p->ts.sig_figs;

                    if (++sum_stat_nr =3D=3D sum_stat_clients) {
                        strcpy(client_ts.name, "All clients");
                        tsobj =3D show_thread_status(&client_ts, &client_gs=
, NULL, NULL);
                        if (tsobj) {
                            json_object_add_client_info(tsobj, client);
                            json_array_add_value_object(clients_array, tsob=
j);
                        }
                    }
                }

And when sum_stat_clients <=3D 1, we never print "All clients" summary.  Ac=
tually, we miss an entire client, so neither the individual client summary =
is output nor the "all clients" summary is output.  It seems one client fin=
ishes just slightly before the other but we remove from the list of clients=
 too quickly.  I tried adjusting the timeout and such, but didn't completel=
y remove the issue.  Any specific thoughts?

I cut down the job files to the smallest I could find to reliably reproduce=
 the issue.  It seems we need to log a few items to reproduce, but the job =
runtime itself can be quite small.


# cat test_job_a
[test_job_a]
description=3Dtest_job_a
ioengine=3Dlibaio
direct=3D1
rw=3Drandread
iodepth=3D8
bs=3D64k
filename=3D/dev/nvme0n1
group_reporting
write_bw_log=3Dtest_job_a
write_iops_log=3Dtest_job_a
write_lat_log=3Dtest_job_a
log_avg_msec=3D1000
unified_rw_reporting=3D1
disable_lat=3D0
disable_clat=3D0
disable_slat=3D0
runtime=3D5s
time_based


# cat test_job_b
[test_job_b]
description=3Dtest_job_b
ioengine=3Dlibaio
direct=3D1
rw=3Drandread
iodepth=3D8
bs=3D64k
filename=3D/dev/nvme0n1
group_reporting
write_bw_log=3Dtest_job_b
write_iops_log=3Dtest_job_b
write_lat_log=3Dtest_job_b
log_avg_msec=3D1000
unified_rw_reporting=3D1
disable_lat=3D0
disable_clat=3D0
disable_slat=3D0
runtime=3D5s
time_based


# fio --client=3Dhost1 test_job_a --client=3Dhost2 test_job_b --output=3Dte=
st_job


Regards,
Jeff


-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jeff Furlong
Sent: Thursday, February 15, 2018 4:33 PM
To: fio@vger.kernel.org
Subject: fio server/client disconnect bug

Hi All,
With the near latest fio version (fio-3.3-51-gf2cd) using server/client mod=
e, I occasionally see one client get disconnected early.  Hence, the client=
's IO summary output does not get reported at the end of the job.  The issu=
e seems to occur between 100 and 300 iterations of a job file.  Worse, the =
conditions for the early disconnect may be tied to the complexity of the jo=
b file (such as numjobs or IOPs of device).  Even worse, when using debug m=
ode, the failure seems to reduce to around 1000 iterations of a job file.

When running with

fio --client=3Dhost1 test_job_a --client=3Dhost2 test_job_b --debug=3Dproce=
ss,net

...
net      5027  client: handle host2
net      5027  client: got cmd op IOLOG from host2 (pdu=3D446)
net      5027  client: handle host2
client: host=3Dhost2 disconnected
net      5027  client: removed <host2>
net      5027  client: request eta (1)
net      5027  client: requested eta tag 0x1b52c20
net      5027  client: handle host1
net      5027  client: got cmd op TEXT from host1 (pdu=3D85)
<host1> net      5028  server: got op [SEND_ETA], pdu=3D0, tag=3D1b4a970
net      5027  client: handle host1
net      5027  client: got cmd op TEXT from host1 (pdu=3D61)
<host1> net      5028  server sending status
...

Then the normal output summary only shows the statistics from host1.  The h=
ost2 throughput, latency, etc. are never displayed.  However, the iops, bw,=
 and lat logs all seem to have been updated properly.  Sometimes host2 is d=
isconnected early; sometimes host1 is disconnected early.

Why might host2 be disconnected?  I see disconnects when using a switch wit=
h one hop and also with directly connecting host1 to host2.  So dropping ne=
twork packets seems unlikely.  Could the ETA update not be accurate?  Or is=
 it possible host2 finishes the job faster than host1 and closes the connec=
tion too early?

In the event host2's job file finishes early, should we still summarize the=
 IO traffic in the output?  How is that condition handled?

If you have suggestions on other debug options, I would appreciate.  Thanks=
.

Regards,
Jeff


