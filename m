Return-Path: <fio-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59496 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbcHHHUv convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 8 Aug 2016 03:20:51 -0400
Date: Mon, 8 Aug 2016 03:20:50 -0400 (EDT)
From: Erwan Velu <evelu@redhat.com>
Message-ID: <1419631133.185964.1470640850603.JavaMail.zimbra@redhat.com>
In-Reply-To: <no67l1$l4$1@blaine.gmane.org>
References: <no67l1$l4$1@blaine.gmane.org>
Subject: Re: fio2gnuplot iop graphs not showing any output
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Saeed <ionictea@gmail.com>
Cc: fio@vger.kernel.org

Hey,

Can you please share with us the output file you get & the exact command line you use ?

----- Mail original -----
De: "Saeed" <ionictea@gmail.com>
À: fio@vger.kernel.org
Envoyé: Dimanche 7 Août 2016 04:50:10
Objet: fio2gnuplot iop graphs not showing any output

Is there any trick to getting fio2gnuplot to plot graphs with data for 
the iop logs?  Its not plotting any data for me currently even thgh the 
job averages about 100k iops in the results output and when it plots 
graphs gnuplot takes a very long time complete the job.

[global]
bs=4k
ioengine=libaio
iodepth=1
size=5g
direct=1
filename=/dev/sde
group_reporting
numjobs=1
per_job_logs=0
write_bw_log=bw
write_iops_log=iops
write_lat_log=lat
[read]
rw=read
time_based=1
runtime=180


--
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
