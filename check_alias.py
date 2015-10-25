#!/usr/bin/env python

import difflib

formula_version_map = {'omero': '52', 'bioformats': '51'}


def get_files_diff(file1, file2):
    with open(file1) as f:
        f1 = f.read().splitlines(1)

    with open(file2) as f:
        f2 = f.read().splitlines(1)

    d = difflib.Differ()
    difflines = [l for l in d.compare(f1, f2)]
    return ([l for l in difflines if l.startswith('-')],
            [l for l in difflines if l.startswith('+')])


def get_expected_diff(formula, version):

    uppercase_formula = formula[0].upper() + formula[1:]
    return (['- class %s%s < Formula\n' % (uppercase_formula, version)],
            ['+ class %s < Formula\n' % uppercase_formula])


for formula, version in formula_version_map.iteritems():
    file1 = 'Formula/%s%s.rb' % (formula, version)
    file2 = 'Formula/%s.rb' % formula
    difflines = get_files_diff(file1, file2)
    print 'Comparing %s and %s' % (file1, file2)
    assert difflines == get_expected_diff(formula, version)
