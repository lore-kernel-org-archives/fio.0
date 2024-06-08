Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3B56125
	for <fio@vger.kernel.org>; Sat,  8 Jun 2024 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717854839; cv=none; b=kXK4l4xsiotVvfCE8bhw7+aBUQybjqPA9UebupneCTIdWxmmIXd7TM5McyOS4YRdzU24G9D7Pt9/151u1AFPOW+OOomX91zpdrOR+RCQoTBGXfPgEJvzUrHfckgB1nzyH2KFjLgUB9KYUOkyR431K0JHeE9zaTSMZhLaI2PyaE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717854839; c=relaxed/simple;
	bh=IHA1/RP0ZdJxBn7lGR7I5nOgG0CG7tlELEZIOZ4oIpA=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JWqp99hsaAjRsakFZr08aM/Qy8taewJ2f/EFb6R+B8+y06yxGp1WT4+Go3l/0qqaQ6L1+3imu0gpFxKJcLpYeCkOF0ALEeqkqKzlq/0VORdnFBj2hNT5vY4rE5iDkd5tA8dTRFiyWkL/eHXWqJDltq9zD1vt0MMR88fVlap6grc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l+lYY5Gr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l+lYY5Gr"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 458DcQBJ001704
	for <fio@vger.kernel.org>; Sat, 8 Jun 2024 13:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:subject:message-id:references:content-type:in-reply-to
	:sender:content-transfer-encoding:mime-version; s=pp1; bh=lq++xY
	G1oHBfANnzv5qtkmksDnf+bI0V0tTmh6S54gs=; b=l+lYY5GrKy/Hm4q8x4yddw
	41M1rbMNN4kGxaYF64x+ERC5WzBy+MesIBlruMJQS43BqjgZf3gTYYyJzRq0Ica3
	+aZJanJL0XdcfSfMvAyOM+c/KEVTMsB5QoNA9lV0pR5uz9/D6ArQ9goP3nnHw8ls
	Xxl3PKnLSZxp64s7M1XEFji5v+XdPEk/VmxTQqcBRNPwXKY+3xfq/rYU52c9OefC
	j4KSDlYfNSge9P4Yz1ZcdVZ8Hc5yde8SA9/KAOmeKrGZ/2XwQYMTaDBNuwK9ox8Q
	UOTC7ZEaASoHSt7am7Nu0HyiXxKjSaOSWQz/PY9s0EiBPBwXXo5hPJT8LNdKBj5g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ymqbbr3xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Sat, 08 Jun 2024 13:53:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 458BktGl011618
	for <fio@vger.kernel.org>; Sat, 8 Jun 2024 13:53:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ymffnt7b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <fio@vger.kernel.org>; Sat, 08 Jun 2024 13:53:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 458DrnN920775264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 8 Jun 2024 13:53:51 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 596892004B;
	Sat,  8 Jun 2024 13:53:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4877C20040;
	Sat,  8 Jun 2024 13:53:49 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.13.161])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat,  8 Jun 2024 13:53:49 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.97.1)
	(envelope-from <bblock@linux.ibm.com>)
	id 1sFwVw-00000004W1X-3yEC;
	Sat, 08 Jun 2024 15:53:48 +0200
Date: Sat, 8 Jun 2024 15:53:48 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: fio list <fio@vger.kernel.org>
Subject: Re: Regression with 40f61ec71936 ("cpus_allowed: use
 __NRPROCESSORS_CONF instead of __SC_NPROCESSORS_ONLN for non-sequential CPU
 ids") and Idleness Profiling
Message-ID: <20240608135348.GB957171@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20240608134436.GA957171@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240608134436.GA957171@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: s9IGUGHY8OorPOz-nuxZDVk91U68n5Y6
X-Proofpoint-ORIG-GUID: s9IGUGHY8OorPOz-nuxZDVk91U68n5Y6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-08_07,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=694 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406080104

On Sat, Jun 08, 2024 at 03:44:36PM +0200, Benjamin Block wrote:
> Making a small change like this to the profiling thread
> 
>     @@ -123,13 +123,11 @@ static void *idle_prof_thread_fn(void *data)
>      
>      	/* exit if other threads failed to initialize */
>      	if (ipc.status == IDLE_PROF_STATUS_ABORT) {
>     -		pthread_mutex_unlock(&ipt->start_lock);
>      		goto do_exit;
>      	}
>      
> v     	/* exit if we are doing calibration only */
>      	if (ipc.status == IDLE_PROF_STATUS_CALI_STOP) {
>     -		pthread_mutex_unlock(&ipt->start_lock);
>      		goto do_exit;
>      	}
>      
>     @@ -151,10 +149,9 @@ static void *idle_prof_thread_fn(void *data)
>      idle_prof_done:
>      
>      	ipt->loops = j + (double) k / page_size;
>     +do_exit:
>      	ipt->state = TD_EXITED;
>      	pthread_mutex_unlock(&ipt->start_lock);
>     -
>     -do_exit:
>      	free_cpu_affinity(ipt);
>      	return NULL;
>      }
> 
> fixes the issue that `fio` doesn't exit in case a profiling thread
> aborts/exits before reaching their main loop.

Ah, this is also buggy :D 

            if (retval == -1) {
                    ipt->state = TD_EXITED;
                    pthread_mutex_unlock(&ipt->init_lock);
                    goto do_exit;
            }

above uses the same label before having locked `ipt->start_lock`, but the idea
applies.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Gesch?ftsf?hrung: David Faller
Sitz der Ges.: B?blingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
