Return-Path: <fio-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:50352 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbBOWa4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 15 Feb 2015 17:30:56 -0500
Received: from zmail16.collab.prod.int.phx2.redhat.com (zmail16.collab.prod.int.phx2.redhat.com [10.5.83.18])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id t1FMUuYm017284
	for <fio@vger.kernel.org>; Sun, 15 Feb 2015 17:30:56 -0500
Date: Sun, 15 Feb 2015 17:30:55 -0500 (EST)
From: Ben England <bengland@redhat.com>
Message-ID: <968967006.10478476.1424039455959.JavaMail.zimbra@redhat.com>
In-Reply-To: <1797629778.10331443.1423937244266.JavaMail.zimbra@redhat.com>
Subject: suggested patch to let fio accept client ips from a file
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following patch will allow fio to accept server IPs from a file.  This is particularly useful when you have large numbers of fio servers (example: virtual machine guests) that participate in a test.  To use this, simply use the --client option but instead of specifying a host name or IP, provide a pathname for a file containing a list of host names/addresses, one host per line.

--- init.c.sav	2015-02-08 05:39:33.507493776 -0500
+++ init.c	2015-02-08 06:00:14.479913391 -0500
@@ -2226,6 +2226,27 @@
 				exit_val = 1;
 				break;
 			}
+                        if (0 == access(optarg, R_OK)) {
+                                /* this is really a file containing a list of host addrs or names */
+                                char hostaddr[257] = {0};
+                                FILE * hostf = fopen(optarg, "r");
+                                if (!hostf) {
+                                        log_err("fio: could not open client list file %s for read\n", optarg);
+                                        do_exit++;
+                                        exit_val = 1;
+                                        break;
+                                }
+                                while (fscanf(hostf, "%s", hostaddr) == 1) {
+                                        if (fio_client_add(&fio_client_ops, hostaddr, &cur_client)) {
+                                                log_err("fio: failed adding client %s from file %s\n", hostaddr, optarg);
+                                                do_exit++;
+                                                exit_val = 1;
+                                                break;
+                                        }
+                                }
+                                fclose(hostf);
+                                break; /* no possibility of job file for "this client only" */
+                        }
 			if (fio_client_add(&fio_client_ops, optarg, &cur_client)) {
 				log_err("fio: failed adding client %s\n", optarg);
 				do_exit++;
