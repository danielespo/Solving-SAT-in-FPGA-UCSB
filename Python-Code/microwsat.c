/************************************************************************************
MicroWalkSAT: A WalkSAT/SKC SAT Solver
=====================================================================================
Copyright (c) 2024 Daniel A. Espinosa Gonzalez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

#define OOT 0
#define SAT 1
#define DEFAULT_MAX_TRIES 5
#define DEFAULT_MAX_FLIPS 100
#define DEFAULT_NOISE 0.57 // updated based on the handbook of SAT 2e

typedef struct
{
    int **clauses;
    int numClauses;
    int numVariables;
} CNF;

typedef struct
{
    CNF cnf;
    int *model;
    int maxTries;
    int maxFlips;
    float noise;
} Solver;

void *safeAlloc(size_t size)
{
    void *ptr = malloc(size);
    if (ptr == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    return ptr;
}

void freeSolver(Solver *S)
{
    for (int i = 0; i < S->cnf.numClauses; i++)
    {
        free(S->cnf.clauses[i]);
    }
    free(S->cnf.clauses);
    free(S->model);
}

void initSolver(Solver *S, int n, int m, int maxTries, int maxFlips)
{
    S->cnf.numVariables = n;
    S->cnf.numClauses = m;
    S->model = safeAlloc((n + 1) * sizeof(int));
    S->maxTries = maxTries;
    S->maxFlips = maxFlips;
    S->noise = DEFAULT_NOISE;
    for (int i = 1; i <= n; i++)
    {
        S->model[i] = rand() % 2;
    }
}

int parse(Solver *S, const char *filename)
{
    FILE *input = fopen(filename, "r");
    if (!input)
    {
        fprintf(stderr, "Error opening file %s\n", filename);
        return 0;
    }

    int nVars = 0, nClauses = 0;
    char line[1024];

    // Read lines until we find the problem line
    while (fgets(line, sizeof(line), input))
    {
        if (line[0] == 'c')
            continue; // Skip comment lines
        if (sscanf(line, "p cnf %d %d", &nVars, &nClauses) == 2)
            break;
    }

    if (nVars == 0 || nClauses == 0)
    {
        fprintf(stderr, "Error: Invalid or missing problem line\n");
        fclose(input);
        return 0;
    }

    initSolver(S, nVars, nClauses, S->maxTries, S->maxFlips);

    S->cnf.clauses = safeAlloc(nClauses * sizeof(int *));
    for (int i = 0; i < nClauses; i++)
    {
        S->cnf.clauses[i] = safeAlloc((nVars + 1) * sizeof(int));
    }

    int clauseIndex = 0;
    int var;
    int clauseSize = 0;

    while (fscanf(input, "%d", &var) == 1)
    {
        if (var == 0)
        {
            if (clauseSize > 0)
            {
                S->cnf.clauses[clauseIndex][clauseSize] = 0; // End of clause marker
                clauseIndex++;
                clauseSize = 0;
            }
        }
        else
        {
            if (clauseIndex >= nClauses)
            {
                fprintf(stderr, "Error: More clauses than specified\n");
                fclose(input);
                freeSolver(S);
                return 0;
            }
            S->cnf.clauses[clauseIndex][clauseSize++] = var;
        }
    }

    if (clauseIndex != nClauses)
    {
        fprintf(stderr, "Error: Fewer clauses than specified\n");
        fclose(input);
        freeSolver(S);
        return 0;
    }

    fclose(input);
    return 1;
}

int evaluateClause(const int *clause, const int *model)
{
    for (int i = 0; clause[i] != 0; i++)
    {
        int lit = clause[i];
        if ((lit > 0 && model[lit] == 1) || (lit < 0 && model[-lit] == 0))
        {
            return 1;
        }
    }
    return 0;
}

int pickRandomUnsatisfiedClause(const Solver *S)
{
    int *unsatisfiedClauses = safeAlloc(S->cnf.numClauses * sizeof(int));
    int count = 0;
    for (int i = 0; i < S->cnf.numClauses; i++)
    {
        if (!evaluateClause(S->cnf.clauses[i], S->model))
        {
            unsatisfiedClauses[count++] = i;
        }
    }

    int clauseIndex = -1;
    if (count > 0)
    {
        clauseIndex = unsatisfiedClauses[rand() % count];
    }
    free(unsatisfiedClauses);
    return clauseIndex;
}

int pickVariableToFlip(const Solver *S, const int *clause)
{
    if ((float)rand() / RAND_MAX < S->noise)
    {
        int clauseLength = 0;
        while (clause[clauseLength] != 0)
            clauseLength++;
        return abs(clause[rand() % clauseLength]);
    }
    else
    {
        int bestVar = abs(clause[0]);
        int bestBreakCount = S->cnf.numClauses;

        for (int i = 0; clause[i] != 0; i++)
        {
            int var = abs(clause[i]);
            int breakCount = 0;

            for (int j = 0; j < S->cnf.numClauses; j++)
            {
                if (evaluateClause(S->cnf.clauses[j], S->model))
                {
                    int wouldBreak = 1;
                    for (int k = 0; S->cnf.clauses[j][k] != 0; k++)
                    {
                        int lit = S->cnf.clauses[j][k];
                        if (abs(lit) != var && ((lit > 0 && S->model[lit] == 1) || (lit < 0 && S->model[-lit] == 0)))
                        {
                            wouldBreak = 0;
                            break;
                        }
                    }
                    if (wouldBreak)
                        breakCount++;
                }
            }

            if (breakCount < bestBreakCount)
            {
                bestBreakCount = breakCount;
                bestVar = var;
            }
        }
        return bestVar;
    }
}

void flipVariable(Solver *S, int var)
{
    S->model[var] = 1 - S->model[var];
}

int solve(Solver *S)
{
    for (int i = 0; i < S->maxTries; i++)
    {
        for (int j = 1; j <= S->cnf.numVariables; j++)
        {
            S->model[j] = rand() % 2;
        }
        for (int k = 0; k < S->maxFlips; k++)
        {
            int clauseIndex = pickRandomUnsatisfiedClause(S);
            if (clauseIndex == -1)
                return SAT;

            int *clause = S->cnf.clauses[clauseIndex];
            int varToFlip = pickVariableToFlip(S, clause);
            flipVariable(S, varToFlip);
        }
    }
    return OOT;
}

void printModel(const Solver *S)
{
    printf("v");
    for (int i = 1; i <= S->cnf.numVariables; i++)
    {
        printf(" %d", S->model[i] ? i : -i);
    }
    printf(" 0\n");
}

int main(int argc, char **argv)
{
    int maxTries = DEFAULT_MAX_TRIES;
    int maxFlips = DEFAULT_MAX_FLIPS;
    int opt;

    while ((opt = getopt(argc, argv, "t:f:")) != -1)
    {
        switch (opt)
        {
        case 't':
            maxTries = atoi(optarg);
            break;
        case 'f':
            maxFlips = atoi(optarg);
            break;
        default:
            fprintf(stderr, "Usage: %s [-t maxTries] [-f maxFlips] <input_file>\n", argv[0]);
            exit(EXIT_FAILURE);
        }
    }

    if (optind >= argc)
    {
        fprintf(stderr, "Expected input file after options\n");
        exit(EXIT_FAILURE);
    }

    Solver S = {0};
    S.maxTries = maxTries;
    S.maxFlips = maxFlips;

    if (!parse(&S, argv[optind]))
    {
        fprintf(stderr, "Failed to parse input file\n");
        return EXIT_FAILURE;
    }

    srand(time(NULL));

    if (solve(&S) == SAT)
    {
        printf("s SATISFIABLE\n");
        printModel(&S);
    }
    else
    {
        printf("s OUT OF TIME\n");
    }

    freeSolver(&S);
    return EXIT_SUCCESS;
}
