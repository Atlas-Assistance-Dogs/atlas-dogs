import csv

with open('datasets/courses.csv', 'w') as csvfile:
    spamwriter = csv.writer(csvfile, delimiter=',',
                            quotechar='"', quoting=csv.QUOTE_MINIMAL)
    spamwriter.writerow(['Course Name', 'Active', 'Positions', 'Course Code', 'Course Name', 'Course SIS', 'Section SIS', 'Term SIS',
                        'Expected Completion'])

    with open('course details.csv') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',', quotechar='"')
        first = True
        for row in spamreader:
            if first:
                first = False
                continue
            section, sis, term, name, _, active, _, _, volunteer, facilitator, trainer, client, owner, scent, public, weeks = row
            positions = []
            if volunteer == 'Y':
                positions.append('Volunteer')
            if facilitator == 'Y':
                positions.append('Team Facilitator')
                positions.append('Team Facilitator Lead')
            if trainer == 'Y':
                positions.append('Trainer')
            if client == 'Y':
                positions.append('Client')
            if owner == 'Y':
                positions.append('Owner Trainer')

            code = sis
            if code.find('testout') != -1:
                code = 'TO-' + code[:-7]
            positions = ';'.join(positions)
            active = active == 'active'

            spamwriter.writerow([section, active, positions, code, name, sis, section, term, weeks])
