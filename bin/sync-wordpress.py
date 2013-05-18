#!/usr/bin/env python

import logging
import time
import re
import xmlrpclib
from optparse import OptionParser

MAX_POSTS = 10000

def decode_iso8601(date):
    # Translate an ISO8601 date to the tuple format used in Python's time
    # module.
    regex = r'^(\d{4})(\d{2})(\d{2})T(\d{2}):(\d{2}):(\d{2})'
    match = re.search(regex, str(date))
    if not match:
        raise Exception, '"%s" is not a correct ISO8601 date format' % date
    else:
        result = match.group(1, 2, 3, 4, 5, 6)
        result = map(int, result)
        result += [0, 1, -1]
        return tuple(result)

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(levelname)-8s %(message)s',
                        datefmt='%H:%M:%S')

    parser = OptionParser()

    parser.set_description("Description:\
     Used to create FOTA Update packages from two FOTA zip files")
    parser.set_usage("%prog -s <source> -t <target> [...]")

    parser.add_option("-s", "--source-url", dest="sourceUrl",
                      help="XML-RPC URL of the source blog",
                      metavar="url")

    parser.add_option("-u", "--source-username", dest="sourceUsername",
                      help="Username for source blog",
                      metavar="username")

    parser.add_option("-p", "--source-password", dest="sourcePassword",
                      help="Password for source blog",
                      metavar="password")

    parser.add_option("-t", "--target-url", dest="targetUrl",
                      help="XML-RPC URL of the source blog",
                      metavar="url")

    parser.add_option("-U", "--target-username", dest="targetUsername",
                      help="Username for target blog",
                      metavar="username")

    parser.add_option("-P", "--target-password", dest="targetPassword",
                      help="Password for target blog",
                      metavar="password")

    (options, args) = parser.parse_args()

    logging.info("Source server: %s" % options.sourceUrl)
    source = xmlrpclib.ServerProxy(options.sourceUrl)
    sourcePosts = source.metaWeblog.getRecentPosts(
        1, options.sourceUsername, options.sourcePassword, MAX_POSTS)
    logging.info("Fetched %d posts" % len(sourcePosts))

    logging.info("Target server: %s" % options.targetUrl)
    target = xmlrpclib.ServerProxy(options.targetUrl)
    targetPosts = target.metaWeblog.getRecentPosts(
        1, options.targetUsername, options.targetPassword, MAX_POSTS)
    logging.info("Fetched %d posts" % len(targetPosts))

    for sp in sourcePosts:
        logging.info("TITLE: %s" % sp['title'])
        logging.debug("DATE:  %s" % time.strftime('%m/%d/%Y %H:%M:%S',
            decode_iso8601(sp['dateCreated'].value)))
        logging.debug('AUTHOR: %s: %s', sp['wp_author_display_name'], sp['wp_author_id'])
        if sp['wp_author_id'] != 1:
            sp['wp_author_id'] = 1
        postId = -1
        for tp in targetPosts:
            if sp['title'] == tp['title']:
                postId = tp['postid']
                logging.debug("    Already exists. Overwriting")
                break
        isPublished = (sp['post_status'] == "publish")
        if postId == -1:
            target.metaWeblog.newPost(
                1,
                options.targetUsername,
                options.targetPassword,
                sp,
                isPublished)
        else:
            target.metaWeblog.editPost(
                postId,
                options.targetUsername,
                options.targetPassword,
                sp,
                isPublished)
