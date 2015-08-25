#!/usr/bin/env python
# -*- coding: utf-8 -*-

try:
    from setuptools import setup, find_packages
except:
    from distutils.core import setup, find_packages

setup(
    name='yaml-resume',
    version='0.0.1',
    description='Generates multiple resume/CV formats from a single YAML source.',
    long_description=''.join(open('README.rst').readlines()),
    keywords='yaml, resume',
    author='Sean Barag',
    author_email='sjbarag@fastmail.fm',
    license='GPLv2',
    packages=find_packages(),
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU General Public License v2 (GPLv2)',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python',
        ]
)
