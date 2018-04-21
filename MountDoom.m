pub = rospublisher('/raw_vel');
sub_bump = rossubscriber('/bump');
sub_accel = rossubscriber('/accel');
message = rosmessage(pub);

roll = deg2rad(-16);
grav = receive(sub_accel);
disp(grav.Data)
grav.Data = [cos(roll), 0 ,- sin(roll);  0 1 0; sin(roll) 0 cos(roll)] * grav.Data;
lambda = 1/16;
sigma = 1.2;
disp(grav.Data(3))
while grav.Data(3) < .975
    heading = atan2(grav.Data(2), grav.Data(1));
    vl = -.1;
    vr = .1;
    if heading < 0
        heading = -1 * heading;
        vl = .1;
        vr = -.1;
    end
    disp(heading)
    message.Data = [vl vr];
    send(pub, message);
    pause(heading / (0.2/0.24))
%     message.Data = [0, 0];
%     send(pub, message);
%     gradients = zeros([1,20]);
%     for i = 1:1:20
%         grav = receive(sub_accel);
%         grav.Data = [cos(roll), 0 ,- sin(roll);  0 1 0; sin(roll) 0 cos(roll)] * grav.Data;
%         gradients(i) = grav.Data(1);
%         message.Data = [0.1, -0.1];
%         send(pub, message);
%         pause(deg2rad(1) / (0.2/0.24))
%         message.Data = [0, 0];
%         send(pub, message);
%     end
%     m, i = max(gradients);
%     message.Data = [-0.1, 0.1];
%     send(pub, message);
%     pause(deg2rad(20 - i) / (0.2/0.24))
%     message.Data = [0, 0];
%     send(pub, message);
    message.Data = [0.07, 0.07];
    send(pub, message);
    pause(.35)
    message.Data = [0, 0];
    send(pub, message);
    pause(.5)
    grav = receive(sub_accel);
    grav.Data = [cos(roll), 0 ,- sin(roll);  0 1 0; sin(roll) 0 cos(roll)] * grav.Data;
end
