Return-Path: <prvs=611231c00=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: RE: fio server/client disconnect bug
Date: Wed, 21 Mar 2018 16:35:21 +0000
Message-ID: <SN6PR04MB4064961E38329062931640B68FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457692506FCB2E385AE2A2E8FCB0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <SN6PR04MB4064CEF242E2091737402D268FAA0@SN6PR04MB4064.namprd04.prod.outlook.com>
 <47cd0e78-d881-a776-7f2d-c292b35e8211@kernel.dk>
 <5d0275d2-889e-314e-63bd-240d326beb47@kernel.dk>
 <33d87376-bbd9-69d9-83e0-120d93bd843d@kernel.dk>
In-Reply-To: <33d87376-bbd9-69d9-83e0-120d93bd843d@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

No client ends in error.  In fact, I get a full set of iops/lat/bw logs fro=
m both clients.  And inspection of those logs looks good; I see the last 10=
00ms timestamp is valid for the duration of runtime.  But only one client p=
rints the summary info to the output file.

Regards,
Jeff


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Wednesday, March 21, 2018 9:28 AM
To: Jeff Furlong <jeff.furlong@wdc.com>; fio@vger.kernel.org
Subject: Re: fio server/client disconnect bug

On 3/21/18 10:19 AM, Jens Axboe wrote:
> On 3/21/18 9:19 AM, Jens Axboe wrote:
>> On 3/20/18 6:16 PM, Jeff Furlong wrote:
>>> Revisiting this issue.  It seems the call stack is:
>>>
>>> fio_handle_clients()
>>>     fio_handle_client()
>>>         case FIO_NET_CMD_TS:
>>>             ops->thread_status(client, cmd);
>>>             .thread_status    =3D handle_ts
>>>                 static void handle_ts(struct fio_client *client, struct=
 fio_net_cmd *cmd)
>>>                 {
>>>                     struct cmd_ts_pdu *p =3D (struct cmd_ts_pdu *) cmd-=
>payload;
>>>                     struct flist_head *opt_list =3D NULL;
>>>                     struct json_object *tsobj;
>>>
>>>                     if (client->opt_lists && p->ts.thread_number <=3D c=
lient->jobs)
>>>                         opt_list =3D=20
>>> &client->opt_lists[p->ts.thread_number - 1];
>>>
>>>                     tsobj =3D show_thread_status(&p->ts, &p->rs, opt_li=
st, NULL);
>>>                     client->did_stat =3D true;
>>>                     if (tsobj) {
>>>                         json_object_add_client_info(tsobj, client);
>>>                         json_array_add_value_object(clients_array, tsob=
j);
>>>                     }
>>>
>>>                     if (sum_stat_clients <=3D 1)
>>>                         return;
>>>
>>>                     sum_thread_stats(&client_ts, &p->ts, sum_stat_nr =
=3D=3D 1);
>>>                     sum_group_stats(&client_gs, &p->rs);
>>>
>>>                     client_ts.members++;
>>>                     client_ts.thread_number =3D p->ts.thread_number;
>>>                     client_ts.groupid =3D p->ts.groupid;
>>>                     client_ts.unified_rw_rep =3D p->ts.unified_rw_rep;
>>>                     client_ts.sig_figs =3D p->ts.sig_figs;
>>>
>>>                     if (++sum_stat_nr =3D=3D sum_stat_clients) {
>>>                         strcpy(client_ts.name, "All clients");
>>>                         tsobj =3D show_thread_status(&client_ts, &clien=
t_gs, NULL, NULL);
>>>                         if (tsobj) {
>>>                             json_object_add_client_info(tsobj, client);
>>>                             json_array_add_value_object(clients_array, =
tsobj);
>>>                         }
>>>                     }
>>>                 }
>>>
>>> And when sum_stat_clients <=3D 1, we never print "All clients" summary.
>>> Actually, we miss an entire client, so neither the individual client=20
>>> summary is output nor the "all clients" summary is output.  It seems=20
>>> one client finishes just slightly before the other but we remove=20
>>> from the list of clients too quickly.  I tried adjusting the timeout=20
>>> and such, but didn't completely remove the issue.  Any specific thought=
s?
>>
>> sum_stat_clients is set when we start everything up, so that should=20
>> always be '2' for your case. So I'm a little puzzled as to what is=20
>> going on here. Do any of the jobs ever end in error, and that's why=20
>> we are missing a report from one of the jobs? Or are you referring to=20
>> timing on receiving the stats output, somehow racing with each other=20
>> and we're missing one of them? The latter could result in displaying=20
>> just one output, and never getting ++sum_stat_nr =3D=3D 2 and displaying=
=20
>> the "All clients" output.
>=20
> Does the below patch change anything for you? I forgot that we get=20
> multiple starts (one from each client, of course), which means that we=20
> really should protect the inc from there.

I don't think that's it, we serially handle the clients, so there should be=
 no room for a race there. Hmm, it's basically back to my theory where we p=
ut a client that hasn't done stats yet. That way we can miss doing the all =
clients display, since that condition will never be met. But I don't see ho=
w that could happen, since I'm assuming that both of your hosts always run =
to completion without error?

--
Jens Axboe


