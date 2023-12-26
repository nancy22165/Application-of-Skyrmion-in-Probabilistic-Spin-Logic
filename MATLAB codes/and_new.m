%Assigning probabilities to each Ku value%
Probabilities = [0 0  0.1  0.2  0.25 0.3 0.5 0.6 0.66 0.8 0.9 1];
Delta_ku = [3 2.5 2 1.5 1 0.5 0 -0.5 -1 -1.5 -2.5 -3];
d = dictionary(Delta_ku,Probabilities);

I0 = 0.5;

%AND operation
m1(1) = mi(lookup(d,0));
m2(1) = mi(lookup(d,-1.5));
for i=1:10000
    I3(i) = I0*(-2 + 2*m1(i) + 2*m2(i));
    m3(i) = mi(lookup(d,I3(i)));
    I1(i+1) = I0*(1 - m2(i) + 2*m3(i));
    m1(i+1) = mi(lookup(d,I1(i+1)));
    I2(i+1) = I0*(1 - m1(i) + 2*m3(i));
    m2(i+1) = mi(lookup(d,I2(i+1)));
end
I3(10001) = I0*(-2 + 2*m1(10001) + 2*m2(10001));
m3(10001) = mi(lookup(d,I3(10001)));

for i=1:10000
    if m1(i)>0 
        m1_out(i)=1;
    else 
        m1_out(i)=0;
    end
end
for i=1:10000
    if m2(i)>0 
        m2_out(i)=1;
    else 
        m2_out(i)=0;
    end
end
for i=1:10000
    if m3(i)>0 
        m3_out(i)=1;
    else 
        m3_out(i)=0;
    end
end

% Perform some computation, e.g., combine the bits to form a 3-bit combination
combined_bits = m1_out * 4 + m2_out * 2 + m3_out; % Assuming m1, m2, m3 are binary values

% Count occurrences of each combination
counts = histcounts(combined_bits, -0.5:7.5);

% Calculate probabilities
probabilities = counts / sum(counts) * 100;

% Create a histogram for the probabilities
bar(0:7, probabilities);
xlabel('p-bit code[A B Y]');
ylabel('Probability (%)'); % Adjust the y-axis label
grid on;

% Modify x-axis labels
xticklabels({'000', '001', '010', '011', '100', '101', '110', '111'});

function m_out = mi(probability)
    % Check if the probability is within the valid range
    if probability < 0 || probability > 1
        error('Probability must be between 0 and 1');
    end

    % Generate a random number between 0 to 1
    randomValue = rand();

    % Return 1 with a higher chance based on the probability
    if randomValue <= probability
        m_out = -1;
    else
        m_out = 1;
    end
end

